import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:unord/blocs/liked_notes_bloc.dart';
import 'package:unord/components/Cards/card_note.dart';
import 'package:unord/components/Cards/card_note_comment.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/network_helper.dart';
import 'package:unord/services/note_service.dart';
import 'package:zoom_widget/zoom_widget.dart';

class DetailVideoScreen extends StatefulWidget {
  final int id;

  DetailVideoScreen({this.id});

  @override
  _DetailVideoScreenState createState() => _DetailVideoScreenState();
}

class _DetailVideoScreenState extends State<DetailVideoScreen>
    with TickerProviderStateMixin {
  // ignore: avoid_init_to_null
  Map data = null;
  // ignore: avoid_init_to_null
  List comments = null;
  BetterPlayerController _betterPlayerController;
  bool showDescription = false, isLoadingNewComment = false;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieveDetailData();
  }

  void initVideo() {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.NETWORK,
      URLs.host.substring(0, URLs.host.length - 1) + data['video']['url'],
    );
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  retrieveDetailData() async {
    Response response =
        await NetworkHelper().get('course-videos/' + widget.id.toString());

    setState(() {
      data = response.data;
    });

    initVideo();

    retrieveAllComments();
  }

  retrieveAllComments() async {
    setState(() {
      comments = null;
    });

    String url =
        'video-comments?_sort=created_at:DESC&course_video.id=${widget.id}';

    Response response = await NetworkHelper().get(url);

    setState(() {
      comments = response.data.cast<Map>();
    });
  }

  void submitComment() async {
    var commentText = commentController.text;
    var userId = Hive.box(boxName).get('user_data')['id'];

    if (commentText.length != 0) {
      setState(() {
        isLoadingNewComment = true;
      });

      await NetworkHelper().post('video-comments',
          {'course_video': widget.id, 'user': userId, 'text': commentText});

      retrieveAllComments();

      data['video_comments'].add({'id': 99999999});

      Fluttertoast.showToast(
          msg: 'Berhasil menambah',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(.7),
          textColor: Colors.white,
          fontSize: 16.0);

      FocusScope.of(context).requestFocus(new FocusNode());

      setState(() {
        isLoadingNewComment = false;
        commentController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: BetterPlayer(
                            controller: _betterPlayerController,
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => setState(() {
                                showDescription = !showDescription;
                              }),
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: 50,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data['title'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2F2F2F),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Center(
                                        child: FaIcon(
                                          showDescription
                                              ? FontAwesomeIcons.chevronUp
                                              : FontAwesomeIcons.chevronDown,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            showDescription
                                ? Text(
                                    '31 Oktober 2020',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Color(0xFF2D2929).withOpacity(.6),
                                    ),
                                  )
                                : Container(),
                            showDescription ? SizedBox(height: 8) : Container(),
                            showDescription
                                ? Text(
                                    data['description'] == null
                                        ? ''
                                        : data['description'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      color: Color(0xFF2D2929),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        decoration: BoxDecoration(
                          color: Color(0xFF928A8A).withOpacity(.5),
                        ),
                      ),
                      comments != null
                          ? Flexible(
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
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            'Komentar',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            comments.length.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Color(0xFF5B5959),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 13),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: comments.length,
                                      itemBuilder: (_, idx) {
                                        return CardNoteComment(
                                          comments: comments,
                                          idx: idx,
                                          forVideo: true,
                                        );
                                      },
                                    ),
                                    SizedBox(height: kToolbarHeight),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: data != null
              ? Container(
                  height: kToolbarHeight,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange[700].withOpacity(.1),
                        offset: Offset(0, -1),
                      )
                    ],
                    border: Border(
                      top: BorderSide(
                        color: Colors.orange[700].withOpacity(.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Container(
                          width: 35,
                          height: 35,
                          child: Hive.box(boxName).get('user_data')['image'] !=
                                  null
                              ? CachedNetworkImage(
                                  imageUrl: URLs.host
                                          .substring(0, URLs.host.length - 1) +
                                      Hive.box(boxName)
                                              .get('user_data')['image']
                                          ['formats']['thumbnail']['url'],
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/default_user_icon.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Tambahkan komentar...',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: submitComment,
                        child: Icon(
                          Icons.send,
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
        ),
        isLoadingNewComment
            ? Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(.4),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
