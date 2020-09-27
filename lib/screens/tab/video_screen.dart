import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unord/blocs/education_bloc.dart';
import 'package:unord/blocs/search_catatan_bloc.dart';
import 'package:unord/blocs/search_video_bloc.dart';
import 'package:unord/blocs/subject_bloc.dart';
import 'package:unord/components/Cards/card_note.dart';
import 'package:unord/components/Cards/card_video.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/network_helper.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
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
            .get('courses?_limit=$perPage&_start=$start&_sort=created_at:DESC');

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
            'courses?_limit=$perPage&_start=$startSearch&_sort=created_at:DESC&title_contains=$query';

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

    String url = 'courses?_limit=$perPage&_start=$start&_sort=created_at:DESC';

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
        'courses?_limit=$perPage&_start=$startSearch&_sort=created_at:DESC&title_contains=$query';

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
            child: BlocBuilder<SearchVideoBloc, String>(
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
                          SizedBox(height: 15),
                          TextTitle(),
                          SizedBox(height: 17.1),
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
                                    child: VideoCard(
                                      data: notes[idx],
                                    ),
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
                                    child: VideoCard(data: searchNotes[idx]),
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
      child: Row(
        children: [
          Text(
            'Video ',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Pembelajaran',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Color(0xFFFA694C),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
