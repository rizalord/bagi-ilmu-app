import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unord/blocs/user_bloc.dart';
import 'package:unord/components/Cards/card_diskusi.dart';
import 'package:unord/components/Cards/card_note.dart';
import 'package:unord/helpers/network_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  List data = [];
  bool isLoading = true, isLoadMore = false, isReachedEnd = false;
  int perPage = 5, start = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    retrieveAllData();
  }

  Future<void> retrieveAllData() async {
    if (this.mounted)
      setState(() {
        isLoading = true;
      });

    Response response1 = await NetworkHelper()
        .get('notes?_start=$start&_limit=$perPage&_sort=created_at:DESC');

    Response response2 = await NetworkHelper()
        .get('prs?_start=$start&_limit=$perPage&_sort=created_at:DESC');

    List tmp = [];

    if (response1.data.length > response2.data.length) {
      for (var item in response1.data) {
        int index = response1.data.indexOf(item);

        tmp.add({
          'type': 1,
          'data': item,
        });

        if (response2.data.asMap().containsKey(index))
          tmp.add({
            'type': 2,
            'data': response2.data[index],
          });
      }
    } else {
      for (var item in response2.data) {
        int index = response2.data.indexOf(item);

        tmp.add({
          'type': 2,
          'data': item,
        });

        if (response1.data.asMap().containsKey(index))
          tmp.add({
            'type': 1,
            'data': response1.data[index],
          });
      }
    }

    if (this.mounted)
      setState(() {
        isLoading = false;
        data = tmp;
        start = 0;
      });
  }

  Future<void> refresh() async {
    await retrieveAllData();
    return true;
  }

  void loadMore() async {
    if (!isReachedEnd) {
      if (this.mounted)
        setState(() {
          isLoadMore = true;
          start += perPage;
        });

      Response response1 = await NetworkHelper()
          .get('notes?_start=$start&_limit=$perPage&_sort=created_at:DESC');

      Response response2 = await NetworkHelper()
          .get('prs?_start=$start&_limit=$perPage&_sort=created_at:DESC');

      List tmp = [];

      if (response1.data.length > response2.data.length) {
        for (var item in response1.data) {
          int index = response1.data.indexOf(item);

          tmp.add({
            'type': 1,
            'data': item,
          });

          if (response2.data.asMap().containsKey(index))
            tmp.add({
              'type': 2,
              'data': response2.data[index],
            });
        }
      } else {
        for (var item in response2.data) {
          int index = response2.data.indexOf(item);

          tmp.add({
            'type': 2,
            'data': item,
          });

          if (response1.data.asMap().containsKey(index))
            tmp.add({
              'type': 1,
              'data': response1.data[index],
            });
        }
      }

      if (tmp.length < (2 * perPage)) {
        isReachedEnd = true;
      }

      if (this.mounted)
        setState(() {
          isLoadMore = false;
          data.addAll(tmp);
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
          onRefresh: retrieveAllData,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Header(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Postingan Baru - Baru Ini',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Color(0xFFBC3686),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                isLoading
                    ? Container(
                        margin: EdgeInsets.only(top: 70),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (_, idx) => data[idx]['type'] == 1
                            ? Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: NoteCard(
                                  data: data[idx]['data'],
                                  showBadge: true,
                                ),
                              )
                            : data[idx]['type'] == 2
                                ? Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: DiskusiCard(
                                      data: data[idx]['data'],
                                      showBadge: true,
                                    ),
                                  )
                                : Container(),
                      ),
                isLoadMore
                    ? Container(
                        padding:
                            EdgeInsets.only(top: 15, bottom: kToolbarHeight),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
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
            width: (MediaQuery.of(context).size.width * .5) - 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Halo,',
                  style: GoogleFonts.roboto(
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                BlocBuilder<UserBloc, Map>(
                  builder: (_, user) => Text(
                    user['username'],
                    style: GoogleFonts.roboto(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Image.asset(
              'assets/images/home_illustration.png',
            ),
          ),
        ],
      ),
    );
  }
}
