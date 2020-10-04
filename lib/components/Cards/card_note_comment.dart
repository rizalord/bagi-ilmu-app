import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/helpers/widget_helper.dart';

class CardNoteComment extends StatelessWidget {
  const CardNoteComment({
    Key key,
    @required this.comments,
    @required this.idx,
    this.forVideo = false,
  }) : super(key: key);

  final List comments;
  final int idx;
  final bool forVideo;

  @override
  Widget build(BuildContext context) {
  return comments[idx]['user'] != null
        ? Container(
            margin: EdgeInsets.only(
              left: forVideo ? 0 : 20,
              right: forVideo ? 0 : 20,
              bottom: 10,
            ),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 1,
                color: Color(0xFFCACACA),
              ),
            ),
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: 12,
            ),
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
                          child: comments[idx]['user']['image'] != null
                              ? WidgetHelper.ImageLoader(
                                  URLs.host.substring(0, URLs.host.length - 1) +
                                      comments[idx]['user']['image']['formats']
                                          ['thumbnail']['url'],
                                )
                              : Image.asset(
                                  'assets/images/default_user_icon.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              comments[idx]['user']['username'],
                              style: GoogleFonts.poppins(
                                fontSize: 15.5,
                                color: Color(0xFF3C3C3C),
                              ),
                            ),
                            Text(
                              ' • ' +
                                  DateFormat('d MMMM y').format(
                                    DateTime.parse(
                                      comments[idx]['updated_at'].toString(),
                                    ),
                                  ),
                              style: GoogleFonts.poppins(
                                fontSize: 10.5,
                                color: Color(0xFF3C3C3C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 8,
                    bottom: 5,
                  ),
                  child: Text(
                    comments[idx]['text'].trim(),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
