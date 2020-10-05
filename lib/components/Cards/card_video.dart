import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unord/blocs/bookmark_bloc.dart';
import 'package:unord/blocs/liked_notes_bloc.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/widget_helper.dart';
import 'package:unord/services/bookmark_service.dart';
import 'package:unord/services/note_service.dart';

class VideoCard extends StatefulWidget {
  const VideoCard({
    Key key,
    this.data,
  }) : super(key: key);

  final Map data;

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  @override
  void initState() {
    super.initState();
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
          onTap: () {
            Modular.to.pushNamed('/playlist/detail', arguments: {
              'id': widget.data['id'],
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * .48,
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: WidgetHelper.ImageLoader(
                            URLs.host.substring(0, URLs.host.length - 1) +
                                (widget.data['thumbnail']['url'] != null
                                    ? widget.data['thumbnail']['url']
                                    : widget.data['thumbnail']['formats']
                                        ['thumbnail']['url']),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width * .35,
                            decoration: BoxDecoration(
                              color: Color(0xFF5C5B5B).withOpacity(.61),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.data['course_videos'].length
                                      .toString(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Video',
                                  style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.data['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              DateFormat('d MMMM y').format(
                                DateTime.parse(
                                  widget.data['updated_at'].toString(),
                                ),
                              ),
                              style: GoogleFonts.poppins(
                                fontSize: 11.2,
                                color: Color(0xFF5B5B5B),
                              ),
                            )
                          ],
                        ),
                      ),
                      BlocBuilder<BookmarkBloc, List<Map>>(
                        builder: (_, bookmarks) {
                          bool isBookmarked = bookmarks
                                  .where((e) =>
                                      e['bookmark_type'] == 3 &&
                                      e['course'] != null)
                                  .toList()
                                  .where((element) =>
                                      element['course'] ==
                                      widget.data['id'])
                                  .toList()
                                  .length >
                              0;

                          return GestureDetector(
                            onTap: () async => !isBookmarked
                                ? await BookmarkService()
                                    .bookmarkVideo(widget.data['id'])
                                : await BookmarkService()
                                    .unbookmarkVideo(widget.data['id']),
                            child: Container(
                              width: 40,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
