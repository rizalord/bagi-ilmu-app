import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:unord/blocs/liked_notes_bloc.dart';
import 'package:unord/components/Cards/card_note_comment.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/network_helper.dart';
import 'package:unord/services/note_service.dart';
import 'package:zoom_widget/zoom_widget.dart';

class DetailPlaylistScreen extends StatefulWidget {
  final int id;

  DetailPlaylistScreen({this.id});

  @override
  _DetailPlaylistScreenState createState() => _DetailPlaylistScreenState();
}

class _DetailPlaylistScreenState extends State<DetailPlaylistScreen>
    with TickerProviderStateMixin {
  // ignore: avoid_init_to_null
  Map data = null;

  @override
  void initState() {
    super.initState();
    retrieveDetailData();
  }

  retrieveDetailData() async {
    Response response =
        await NetworkHelper().get('courses/' + widget.id.toString());

    setState(() {
      data = response.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Video ',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text(
              'Pembelajaran',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xFFFA694C),
              ),
            ),
          ],
        ),
        actions: [
          Container(width: 40),
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).textSelectionColor,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: data != null
          ? SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            top: 30,
                            left: 15,
                            bottom: 35,
                            right: 15,
                          ),
                          color: Color(0xFFF4F3F2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'],
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                data['author'],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF929090),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                data['description'],
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Color(0xFF373535),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 20,
                        child: GestureDetector(
                          onTap: () => Modular.to.pushNamed(
                            '/video/detail',
                            arguments: {
                              'id': data['course_videos'].first['id'],
                            },
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                              ),
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                        top: 15,
                        left: 15,
                        bottom: 10,
                        right: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['course_videos'].length.toString() + ' Video',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 13),
                          ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data['course_videos'].length,
                            itemBuilder: (_, idx) => Container(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () => Modular.to.pushNamed(
                                      '/video/detail',
                                      arguments: {
                                        'id': data['course_videos'][idx]['id'],
                                      },
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .26,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[350],
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: URLs.host.substring(
                                                      0, URLs.host.length - 1) +
                                                  data['course_videos'][idx]
                                                              ['thumbnail']
                                                          ['formats']
                                                      ['thumbnail']['url'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Text(
                                              data['course_videos'][idx]
                                                  ['title'],
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
