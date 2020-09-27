import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unord/blocs/education_bloc.dart';
import 'package:unord/blocs/search_catatan_bloc.dart';
import 'package:unord/blocs/subject_bloc.dart';
import 'package:unord/components/Cards/card_note.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/network_helper.dart';

class CatatanScreen extends StatefulWidget {
  @override
  _CatatanScreenState createState() => _CatatanScreenState();
}

class _CatatanScreenState extends State<CatatanScreen>
    with AutomaticKeepAliveClientMixin {
  List notes = [], searchNotes = [];
  bool isLoading = true,
      isLoadingMore = false,
      isReached = false,
      isLoadingSearch = true,
      isLoadingMoreSearch = false;
  int perPage = 5, start = 0, startSearch = 0;
  String query = '';
  List<Map> educations = [
    {'id': 0, 'text': 'Pilih Jenjang Pendidikan'}
  ];
  int pickedEducation = 0;
  // ignore: avoid_init_to_null
  int pickedSubject = null;

  @override
  void initState() {
    super.initState();

    retrieveAllData();
  }

  void loadMore() async {
    if (!isReached) {
      if (query.length == 0) {
        start += perPage;
        if (this.mounted)
          setState(() {
            isLoadingMore = true;
          });

        Response response = await NetworkHelper()
            .get('notes?_limit=$perPage&_start=$start&_sort=created_at:DESC');

        if (this.mounted)
          setState(() {
            isLoadingMore = false;
            isReached = response.data.length < perPage;
            notes.addAll(response.data);
          });
      } else {
        startSearch += perPage;
        if (this.mounted)
          setState(() {
            isLoadingMoreSearch = true;
          });

        String url =
            'notes?_limit=$perPage&_start=$startSearch&_sort=created_at:DESC&title_contains=$query';

        if (pickedEducation != 0) url += '&education.id=$pickedEducation';
        if (pickedSubject != null) url += '&subject.id=$pickedSubject';

        Response response = await NetworkHelper().get(url);

        if (this.mounted)
          setState(() {
            isLoadingMoreSearch = false;
            isReached = response.data.length < perPage;
            searchNotes.addAll(response.data);
          });
      }
    }
  }

  void retrieveAllData() async {
    if (this.mounted)
      setState(() {
        isLoading = true;
      });

    String url = 'notes?_limit=$perPage&_start=$start&_sort=created_at:DESC';

    if (pickedEducation != 0) url += '&education.id=$pickedEducation';
    if (pickedSubject != null) url += '&subject.id=$pickedSubject';

    Response response = await NetworkHelper().get(url);

    if (this.mounted)
      setState(() {
        isLoading = false;
        notes = response.data;
      });
  }

  Future<void> onRefresh() async {
    if (query.length == 0) {
      isLoadingMore = false;
      isReached = false;
      start = 0;

      retrieveAllData();
    } else {
      isLoadingMoreSearch = false;
      isReached = false;
      startSearch = 0;

      retrieveAllDataSearch();
    }

    return true;
  }

  toggleSubject(Map data) {
    if (pickedSubject == null) {
      setState(() {
        pickedSubject = data['id'];
      });
    } else if (pickedSubject != data['id']) {
      setState(() {
        pickedSubject = data['id'];
      });
    } else {
      setState(() {
        pickedSubject = null;
      });
    }

    retrieveAllDataSearch();
  }

  void retrieveAllDataSearch() async {
    setState(() {
      isLoadingSearch = true;
      isReached = false;
      isLoadingMoreSearch = false;
      startSearch = 0;
    });

    String url =
        'notes?_limit=$perPage&_start=$startSearch&_sort=created_at:DESC&title_contains=$query';

    if (pickedEducation != 0) url += '&education.id=$pickedEducation';
    if (pickedSubject != null) url += '&subject.id=$pickedSubject';

    Response response = await NetworkHelper().get(url);

    setState(() {
      isLoadingSearch = false;
      searchNotes = response.data;
    });
  }

  void clearSearchResult() {
    if (this.mounted) {
      setState(() {
        isLoadingSearch = false;
        searchNotes = [];
        isLoadingMoreSearch = false;
        isReached = false;
        startSearch = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) loadMore();
        },
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: BlocBuilder<SearchCatatanBloc, String>(
              builder: (_, searchQuery) {
                if (this.mounted && query != searchQuery) {
                  query = searchQuery;
                  Future.delayed(Duration.zero, () async {
                    if (searchQuery.length == 0) {
                      clearSearchResult();
                    } else {
                      retrieveAllDataSearch();
                    }
                  });
                }

                return searchQuery.length == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Header(),
                          TextTitle(),
                          SizedBox(height: 11),
                          isLoading
                              ? Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: notes.length,
                                  itemBuilder: (ctx, idx) => Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: NoteCard(data: notes[idx]),
                                  ),
                                ),
                          isLoadingMore
                              ? Container(
                                  margin: EdgeInsets.only(top: 22, bottom: 22),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * .13,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: BlocBuilder<EducationBloc, List<Map>>(
                              builder: (_, eduBloc) {
                                List<Map> newData = List.from(educations);
                                newData.addAll(eduBloc);

                                return DropdownButton(
                                  isExpanded: true,
                                  value: pickedEducation,
                                  underline: Container(),
                                  hint: Text("Pilih Jenjang Pendidikan"),
                                  items: newData
                                      .map(
                                        (e) => DropdownMenuItem(
                                          child: Text(
                                            e['text'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF423431),
                                            ),
                                          ),
                                          value: e['id'],
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      pickedEducation = value;
                                    });
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    retrieveAllDataSearch();
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: BlocBuilder<SubjectBloc, List<Map>>(
                                builder: (_, subjectBloc) {
                                  List newData = subjectBloc
                                      .where((e) {
                                        return availableSubject
                                                .where((element) =>
                                                    element['id'] == e['id'])
                                                .toList()
                                                .length >
                                            0;
                                      })
                                      .toList()
                                      .map((e) {
                                        return availableSubject
                                            .where((element) =>
                                                element['id'] == e['id'])
                                            .toList()
                                            .first;
                                      })
                                      .toList()
                                      .reversed
                                      .toList();

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: newData
                                        .map(
                                          (e) => GestureDetector(
                                            onTap: () => toggleSubject(e),
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                left: 15,
                                                right: newData.indexOf(e) ==
                                                        newData.length - 1
                                                    ? 15
                                                    : 0,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .22,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .22,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .22,
                                                    decoration: BoxDecoration(
                                                      color: e['color'],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10,
                                                      ),
                                                      border: Border.all(
                                                        color: Color(0xFFFA694C)
                                                            .withOpacity(
                                                                pickedSubject ==
                                                                        e['id']
                                                                    ? 1
                                                                    : 0),
                                                        width: pickedSubject ==
                                                                e['id']
                                                            ? 3
                                                            : 0,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: FaIcon(
                                                        e['icon'],
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    e['title'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: pickedSubject ==
                                                              e['id']
                                                          ? Color(0xFFFA694C)
                                                          : Colors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            height: 1,
                            color: Colors.black.withOpacity(.1),
                          ),
                          SizedBox(height: 17.8),
                          isLoadingSearch
                              ? Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: searchNotes.length,
                                  itemBuilder: (ctx, idx) => Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: NoteCard(data: searchNotes[idx]),
                                  ),
                                ),
                          isLoadingMoreSearch
                              ? Container(
                                  margin: EdgeInsets.only(top: 22, bottom: 22),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Container(),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

class TextTitle extends StatelessWidget {
  const TextTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      child: Text(
        'Catatan Terbaru',
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(
          fontSize: 18,
          color: Color(0xFFFA694C),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * .5,
      padding: EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width * .55) - 15 - 5,
            child: Text(
              'Bagikan Catatanmu Disini !',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3F3737),
              ),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Image.asset(
              'assets/images/catatan_illustration.png',
            ),
          ),
        ],
      ),
    );
  }
}
