import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unord/blocs/search_catatan_bloc.dart';
import 'package:unord/components/Cards/card_note.dart';
import 'package:unord/helpers/network_helper.dart';

class CatatanScreen extends StatefulWidget {
  @override
  _CatatanScreenState createState() => _CatatanScreenState();
}

class _CatatanScreenState extends State<CatatanScreen>
    with AutomaticKeepAliveClientMixin {
  List notes = [];
  bool isLoading = true, isLoadingMore = false, isReached = false;
  int perPage = 2, start = 0;
  String query = '';

  @override
  void initState() {
    super.initState();

    retrieveAllData();
  }

  void loadMore() async {
    if (!isReached) {
      start += perPage;
      setState(() {
        isLoadingMore = true;
      });

      Response response = await NetworkHelper()
          .get('notes?_limit=$perPage&_start=$start&title_contains=$query&_sort=created_at:DESC');

      setState(() {
        isLoadingMore = false;
        isReached = response.data.length < perPage;
        notes.addAll(response.data);
      });
    }
  }

  void retrieveAllData() async {
    setState(() {
      isLoading = true;
    });

    Response response = await NetworkHelper()
        .get('notes?_limit=$perPage&_start=$start&title_contains=$query&_sort=created_at:DESC');

    setState(() {
      isLoading = false;
      notes = response.data;
    });
  }

  Future<void> onRefresh() async {
    isLoadingMore = false;
    isReached = false;
    start = 0;

    retrieveAllData();

    return true;
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
              builder: (_, searchQuery) => searchQuery.length == 0
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
                      children: [],
                    ),
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
