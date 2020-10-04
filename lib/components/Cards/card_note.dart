import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unord/blocs/bookmark_bloc.dart';
import 'package:unord/blocs/liked_notes_bloc.dart';
import 'package:unord/components/error/image_404.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/network_helper.dart';
import 'package:unord/helpers/widget_helper.dart';
import 'package:unord/services/bookmark_service.dart';
import 'package:unord/services/note_service.dart';

class NoteCard extends StatefulWidget {
  const NoteCard({
    Key key,
    this.data,
    this.showBadge = false,
    this.enableDelete = false,
    this.deleteCallback,
  }) : super(key: key);

  final Map data;
  final bool showBadge, enableDelete;
  final Function deleteCallback;

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  int likes = 0;
  @override
  void initState() {
    likes = widget.data['note_likes'].length;
    super.initState();
  }

  void toggleLike(List<Map> listLiked) async {
    bool isLiked = listLiked
            .where((element) => element['id_catatan'] == widget.data['id'])
            .toList()
            .length >
        0;

    if (isLiked) {
      if (await NoteService().unlike(widget.data['id'])) {
        setState(() {
          likes -= 1;
        });
      }
    } else {
      if (await NoteService().like(widget.data['id']))
        setState(() {
          likes += 1;
        });
    }
  }

  Future<bool> checkIsExist() async {
    Response response =
        await NetworkHelper().get('/notes/' + widget.data['id'].toString());

    if (response.data.runtimeType == String) {
      Fluttertoast.showToast(
          msg: 'Catatan tidak ditemukan',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(.7),
          textColor: Colors.white,
          fontSize: 16.0);
    }

    return response.data.runtimeType != String;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1,
            color: Color(0xFFD8D8D8),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            if (await checkIsExist())
              Modular.to.pushNamed('/note/detail', arguments: {
                'id': widget.data['id'],
              });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                          child: widget.data['user']['image'] != null
                              ? widget.data['user']['image']['formats']
                                          ['thumbnail']['url'] !=
                                      null
                                  ? WidgetHelper.ImageLoader(
                                      URLs.host.substring(
                                              0, URLs.host.length - 1) +
                                          widget.data['user']['image']
                                              ['formats']['thumbnail']['url'],
                                    )
                                  : Image.asset(
                                      'assets/images/default_user_icon.png',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.data['user']['username'],
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: Color(0xFF3C3C3C),
                              ),
                            ),
                            Text(
                              widget.data['education']['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Color(0xFF9E9A9A),
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<BookmarkBloc, List<Map>>(
                        builder: (_, bookmarks) {
                          bool isBookmarked = bookmarks
                                  .where((e) =>
                                      e['bookmark_type']['id'] == 1 &&
                                      e['note'] != null)
                                  .toList()
                                  .where((element) =>
                                      element['note']['id'] ==
                                      widget.data['id'])
                                  .toList()
                                  .length >
                              0;

                          return GestureDetector(
                            onTap: () async {
                              if (await checkIsExist()) {
                                !isBookmarked
                                    ? await BookmarkService()
                                        .bookmarkNote(widget.data['id'])
                                    : await BookmarkService()
                                        .unbookmarkNote(widget.data['id']);
                              }
                            },
                            child: Container(
                              child: Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                              ),
                            ),
                          );
                        },
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
                    child: widget.data['image'] == null
                        ? Image.asset(
                            'assets/images/404.jpg',
                            fit: BoxFit.cover,
                          )
                        : WidgetHelper.ImageLoader(
                            URLs.host.substring(0, URLs.host.length - 1) +
                                (widget.data['image']['url'] != null
                                    ? widget.data['image']['url']
                                    : widget.data['image']['formats']
                                        ['thumbnail']['url']),
                          ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.data['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Color(0xFF423838),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.data['note_views'].length.toString() +
                                  ' views',
                              style: GoogleFonts.poppins(
                                fontSize: 11.2,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              DateFormat('d MMMM y').format(DateTime.parse(
                                  widget.data['updated_at'].toString())),
                              style: GoogleFonts.poppins(
                                fontSize: 11.2,
                                color: Color(0xFF5B5B5B),
                              ),
                            ),
                            widget.showBadge
                                ? Row(
                                    children: [
                                      SizedBox(width: 15),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange[700],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Catatan',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BlocBuilder<LikedNotesBloc, List<Map>>(
                        builder: (_, listLiked) => GestureDetector(
                          onTap: () async {
                            if (await checkIsExist()) toggleLike(listLiked);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  listLiked
                                              .where((element) =>
                                                  element['id_catatan'] ==
                                                  widget.data['id'])
                                              .toList()
                                              .length >
                                          0
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.pink,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  likes.toString() + ' likes',
                                  style: GoogleFonts.poppins(
                                      fontSize: 11.2, color: Colors.pink),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Icon(Icons.comment),
                      SizedBox(width: 5),
                      Text(
                        widget.data['note_comments'].length.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 11.2,
                          color: Colors.black,
                        ),
                      ),
                      widget.enableDelete
                          ? Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(
                                          'Apa anda yakin untuk menghapus?'),
                                      actions: [
                                        FlatButton(
                                          onPressed: () => Modular.to.pop(),
                                          child: Text('Tidak'),
                                        ),
                                        FlatButton(
                                          onPressed: () async {
                                            await NetworkHelper().delete(
                                              'notes/' +
                                                  widget.data['id'].toString(),
                                            );
                                            Modular.to.pop();
                                            Future.delayed(
                                                Duration(milliseconds: 500),
                                                () {
                                              widget.deleteCallback();
                                            });
                                          },
                                          child: Text('Ya'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'Hapus',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
