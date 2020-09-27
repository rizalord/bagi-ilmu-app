import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:unord/blocs/bookmark_bloc.dart';
import 'package:unord/components/Cards/card_diskusi.dart';
import 'package:unord/components/Cards/card_note.dart';
import 'package:unord/components/Cards/card_video.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/network_helper.dart';

class ListBookmarkScreen extends StatefulWidget {
  @override
  _ListBookmarkScreenState createState() => _ListBookmarkScreenState();
}

class _ListBookmarkScreenState extends State<ListBookmarkScreen> {
  List data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    retrieveAllData();
  }

  retrieveAllData() async {
    List bookmarks = Hive.box(boxName).get('bookmarks', defaultValue: []);
    for (var element in bookmarks) {
      if (element['bookmark_type']['id'] == 1 && element['note'] != null) {
        Response response = await NetworkHelper()
            .get('notes/' + element['note']['id'].toString());

        data.add({'bookmark_type': 1, 'data': response.data});
      } else if (element['bookmark_type']['id'] == 2 && element['pr'] != null) {
        Response response =
            await NetworkHelper().get('prs/' + element['pr']['id'].toString());

        data.add({'bookmark_type': 2, 'data': response.data});
      } else if (element['bookmark_type']['id'] == 3 &&
          element['course'] != null) {
        Response response = await NetworkHelper()
            .get('courses/' + element['course']['id'].toString());

        data.add({'bookmark_type': 3, 'data': response.data});
      }
    }

    if (this.mounted)
      setState(() {
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Bookmarks',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : data.length == 0
              ? Center(
                  child: Text(
                    'Belum Ada Bookmark',
                    style: GoogleFonts.poppins(),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (_, item) {
                          if (data[item]['bookmark_type'] == 1) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: NoteCard(
                                data: data[item]['data'],
                                showBadge: true,
                              ),
                            );
                          }

                          if (data[item]['bookmark_type'] == 2) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: DiskusiCard(
                                data: data[item]['data'],
                                showBadge: true,
                              ),
                            );
                          }

                          if (data[item]['bookmark_type'] == 3) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: VideoCard(
                                data: data[item]['data'],
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
    );
  }
}
