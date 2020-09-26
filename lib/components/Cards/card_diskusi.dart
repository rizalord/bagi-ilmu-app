import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:unord/blocs/liked_diskusi_bloc.dart';
import 'package:unord/blocs/liked_notes_bloc.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/services/diskusi_service.dart';
import 'package:unord/services/note_service.dart';

class DiskusiCard extends StatefulWidget {
  const DiskusiCard({
    Key key,
    this.data,
  }) : super(key: key);

  final Map data;

  @override
  _DiskusiCardState createState() => _DiskusiCardState();
}

class _DiskusiCardState extends State<DiskusiCard> {
  int likes = 0;
  @override
  void initState() {
    likes = widget.data['pr_likes'].length;
    super.initState();
  }

  void toggleLike(List<Map> listLiked) async {
    bool isLiked = listLiked
            .where((element) => element['id_diskusi'] == widget.data['id'])
            .toList()
            .length >
        0;

    if (isLiked) {
      if (await DiskusiService().unlike(widget.data['id'])) {
        setState(() {
          likes -= 1;
        });
      }
    } else {
      if (await DiskusiService().like(widget.data['id']))
        setState(() {
          likes += 1;
        });
    }
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
            Modular.to.pushNamed('/diskusi/detail', arguments: {
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
                              ? CachedNetworkImage(
                                  imageUrl: URLs.host
                                          .substring(0, URLs.host.length - 1) +
                                      widget.data['user']['image']['formats']
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
                      imageUrl: URLs.host.substring(0, URLs.host.length - 1) +
                          (widget.data['image']['url'] != null
                              ? widget.data['image']['url']
                              : widget.data['image']['formats']['thumbnail']
                                  ['url']),
                      fit: BoxFit.cover,
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
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.data['pr_views'].length.toString() +
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
                      BlocBuilder<LikedDiskusiBloc, List<Map>>(
                        builder: (_, listLiked) => GestureDetector(
                          onTap: () {
                            toggleLike(listLiked);
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Icon(
                                  listLiked
                                              .where((element) =>
                                                  element['id_diskusi'] ==
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
                        widget.data['pr_comments'].length.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 11.2,
                          color: Colors.black,
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
    );
  }
}
