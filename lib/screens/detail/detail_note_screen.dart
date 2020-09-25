import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:unord/blocs/liked_notes_bloc.dart';
import 'package:unord/components/Cards/card_note_comment.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/network_helper.dart';
import 'package:unord/services/note_service.dart';

class DetailNoteScreen extends StatefulWidget {
  final int id;

  DetailNoteScreen({this.id});

  @override
  _DetailNoteScreenState createState() => _DetailNoteScreenState();
}

class _DetailNoteScreenState extends State<DetailNoteScreen> {
  Map detail = null;
  int likes = 0;
  int perPage = 3, start = 0;
  bool isLoading = false,
      isLoadingNewComment = false,
      isLoadingMore = false,
      isReached = false;
  List comments = [];
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieveDetailData();
    registerView();
  }

  void registerView() async {
    var userId = Hive.box(boxName).get('user_data')['id'];

    Response response = await NetworkHelper()
        .get('note-views/count?note.id=${widget.id}&user.id=$userId');

    if (response.data == 0) {
      await NetworkHelper().post('note-views', {
        'note': widget.id,
        'user': userId,
      });
    }
  }

  retrieveDetailData() async {
    Response response =
        await NetworkHelper().get('notes/' + widget.id.toString());

    setState(() {
      detail = response.data;
      likes = response.data['note_likes'].length;
    });

    retrieveAllComments();
  }

  retrieveAllComments() async {
    setState(() {
      start = 0;
      isReached = false;
      isLoading = true;
    });

    String url =
        'note-comments?_limit=$perPage&_start=$start&_sort=created_at:DESC&note.id=${widget.id}';

    Response response = await NetworkHelper().get(url);

    setState(() {
      isLoading = false;
      comments = response.data.cast<Map>();
    });
  }

  void toggleLike(List<Map> listLiked) async {
    bool isLiked = listLiked
            .where((element) => element['id_catatan'] == widget.id)
            .toList()
            .length >
        0;

    if (isLiked) {
      if (await NoteService().unlike(widget.id)) {
        setState(() {
          likes -= 1;
        });
      }
    } else {
      if (await NoteService().like(widget.id))
        setState(() {
          likes += 1;
        });
    }
  }

  void submitComment() async {
    var commentText = commentController.text;
    var userId = Hive.box(boxName).get('user_data')['id'];

    if (commentText.length != 0) {
      setState(() {
        isLoadingNewComment = true;
      });

      await NetworkHelper().post('note-comments',
          {'note': widget.id, 'user': userId, 'text': commentText});

      retrieveAllComments();

      detail['note_comments'].add({'id': 99999999});

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

  void loadMore() async {
    if (!isReached) {
      start += perPage;
      setState(() {
        isLoadingMore = true;
      });

      Response response = await NetworkHelper().get(
          'note-comments?_limit=$perPage&_start=$start&_sort=created_at:DESC&note.id=${widget.id}');

      setState(() {
        isLoadingMore = false;
        isReached = response.data.length < perPage;
        comments.addAll(response.data.cast<Map>());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Detail',
              style: TextStyle(color: Color(0xFFFA694C)),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).textSelectionColor,
            iconTheme: IconThemeData(color: Color(0xFFFA694C)),
          ),
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) loadMore();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  detail != null ? SizedBox(height: 25) : Container(),
                  detail != null
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(33),
                                      child: Container(
                                        width: 33,
                                        height: 33,
                                        child: detail['user']['image'] != null
                                            ? CachedNetworkImage(
                                                imageUrl: URLs.host.substring(0,
                                                        URLs.host.length - 1) +
                                                    detail['user']['image']
                                                            ['formats']
                                                        ['thumbnail']['url'],
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/images/default_user_icon.png',
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            detail['user']['username'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Color(0xFF3C3C3C),
                                            ),
                                          ),
                                          Text(
                                            detail['education']['title'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Color(0xFF9E9A9A),
                                              height: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width * .48,
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: CachedNetworkImage(
                                    imageUrl: URLs.host.substring(
                                            0, URLs.host.length - 1) +
                                        (detail['image']['url'] != null
                                            ? detail['image']['url']
                                            : detail['image']['formats']
                                                ['thumbnail']['url']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      detail['title'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        color: Color(0xFF423838),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    detail['description'].length != 0
                                        ? Text(
                                            detail['description'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: Color(0xFF353434),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    BlocBuilder<LikedNotesBloc, List<Map>>(
                                      builder: (_, listLiked) =>
                                          GestureDetector(
                                        onTap: () {
                                          toggleLike(listLiked);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              (20 * 2),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      listLiked
                                                                  .where((element) =>
                                                                      element[
                                                                          'id_catatan'] ==
                                                                      widget.id)
                                                                  .toList()
                                                                  .length >
                                                              0
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: Colors.pink,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      likes.toString() +
                                                          ' likes',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 11.2,
                                                              color:
                                                                  Colors.pink),
                                                    ),
                                                    SizedBox(width: 15),
                                                    Icon(Icons.comment),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      detail['note_comments']
                                                          .length
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 11.2,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      detail['note_views']
                                                              .length
                                                              .toString() +
                                                          ' views',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 11.2,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(width: 11.8),
                                                    Text(
                                                      DateFormat('d MMMM y')
                                                          .format(DateTime.parse(
                                                              detail['updated_at']
                                                                  .toString())),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 11.2,
                                                        color:
                                                            Color(0xFF5B5B5B),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                                // valueColor:
                                //     new AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                          ),
                        ),
                  detail != null
                      ? Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: Colors.black.withOpacity(.1),
                        )
                      : Container(),
                  isLoading
                      ? Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * .2,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                                // valueColor:
                                //     new AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (_, idx) => CardNoteComment(
                            comments: comments,
                            idx: idx,
                          ),
                        ),
                  isLoadingMore
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 22, bottom: 22),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(),
                  SizedBox(height: kToolbarHeight),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: detail != null
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
