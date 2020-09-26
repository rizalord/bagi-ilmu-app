import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:unord/blocs/voted_comment_bloc.dart';
import 'package:unord/data/constants.dart';
import 'package:unord/services/diskusi_service.dart';

class CardDiskusiComment extends StatefulWidget {
  const CardDiskusiComment({
    Key key,
    @required this.comments,
    @required this.idx,
    this.isAdmin,
    this.callback,
  }) : super(key: key);

  final List comments;
  final int idx;
  final bool isAdmin;
  final Function callback;

  @override
  _CardDiskusiCommentState createState() => _CardDiskusiCommentState();
}

class _CardDiskusiCommentState extends State<CardDiskusiComment> {
  int votes = 0;
  bool alreadyVote = null;
  bool isTagged = false;

  @override
  void initState() {
    super.initState();
    countVote();
    tagChecker();
  }

  void tagChecker() {
    setState(() {
      isTagged = widget.comments
              .where((element) => element['correct'] == true)
              .toList()
              .length >
          0;
    });
  }

  void countVote() {
    List votes = widget.comments[widget.idx]['pr_vote_comments'];
    int upvotes = votes.where((e) => e['isUpvoted'] == true).toList().length;
    int downvotes = votes
        .where((e) => e['isUpvoted'] == null || e['isUpvoted'] == false)
        .toList()
        .length;

    setState(() {
      this.votes = upvotes - downvotes;
    });
  }

  void doVote() async {
    int idKomen = widget.comments[widget.idx]['id'];

    if (alreadyVote == null) {
      if (await DiskusiService().upvote(idKomen)) {
        setState(() {
          votes++;
          alreadyVote = true;
        });
      }
    } else if (alreadyVote == false) {
      await DiskusiService().deletePreviousVote(idKomen);

      setState(() {
        votes++;
        alreadyVote = null;
      });
    }

    // if (await DiskusiService().upvote(idKomen)) {
    //   setState(() {
    //     if (alreadyVote == false) {
    //       votes == upvotes - downvotes ? votes++ : votes += 2;
    //     } else {
    //       votes++;
    //     }
    //   });
    // }
  }

  void doUnvote() async {
    int idKomen = widget.comments[widget.idx]['id'];

    if (alreadyVote == null) {
      if (await DiskusiService().downvote(idKomen)) {
        setState(() {
          votes--;
          alreadyVote = false;
        });
      }
    } else if (alreadyVote == true) {
      await DiskusiService().deletePreviousVote(idKomen);

      setState(() {
        votes--;
        alreadyVote = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFFFBFBFB),
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
                    child: widget.comments[widget.idx]['user']['image'] != null
                        ? CachedNetworkImage(
                            imageUrl:
                                URLs.host.substring(0, URLs.host.length - 1) +
                                    widget.comments[widget.idx]['user']['image']
                                        ['formats']['thumbnail']['url'],
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/default_user_icon.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.comments[widget.idx]['user']['username'],
                    style: GoogleFonts.poppins(
                      fontSize: 15.5,
                      color: Color(0xFF3C3C3C),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                widget.isAdmin == true && isTagged == false
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4.5,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFDFDADA),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            widget.callback(widget.idx);
                          },
                          child: Row(
                            children: [
                              Text(
                                'Tandai Benar',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Color(0xFF231C1C),
                                ),
                              ),
                              SizedBox(width: 3.8),
                              Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      )
                    : isTagged == true &&
                            widget.comments[widget.idx]['correct'] == true
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4.5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple[700],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Benar',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 3.8),
                                Icon(
                                  Icons.check,
                                  color: Colors.greenAccent,
                                  size: 16,
                                )
                              ],
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              top: 8,
              bottom: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      BlocBuilder<VotedCommentBloc, List<Map>>(
                        builder: (_, votesBloc) {
                          bool isVoted = votesBloc
                                  .where((e) =>
                                      e['id_comment'] ==
                                      widget.comments[widget.idx]['id'])
                                  .toList()
                                  .length >
                              0;

                          if (isVoted) {
                            alreadyVote = votesBloc
                                .where((e) =>
                                    e['id_comment'] ==
                                    widget.comments[widget.idx]['id'])
                                .toList()
                                .first['is_upvoted'];
                          } else {
                            alreadyVote = null;
                          }

                          if (isVoted) {
                            Map data = votesBloc
                                .where((e) =>
                                    e['id_comment'] ==
                                    widget.comments[widget.idx]['id'])
                                .toList()
                                .first;

                            if (data['is_upvoted'] == true) {
                              alreadyVote = true;
                              return FaIcon(
                                FontAwesomeIcons.chevronUp,
                                size: 20,
                                color: Colors.grey[500],
                              );
                            }
                          }

                          return GestureDetector(
                            onTap: doVote,
                            child: FaIcon(
                              FontAwesomeIcons.chevronUp,
                              size: 20,
                              color: Colors.purple,
                            ),
                          );
                        },
                      ),
                      Text(votes.toString()),
                      BlocBuilder<VotedCommentBloc, List<Map>>(
                        builder: (_, votesBloc) {
                          bool isVoted = votesBloc
                                  .where((e) =>
                                      e['id_comment'] ==
                                      widget.comments[widget.idx]['id'])
                                  .toList()
                                  .length >
                              0;

                          if (isVoted) {
                            alreadyVote = votesBloc
                                .where((e) =>
                                    e['id_comment'] ==
                                    widget.comments[widget.idx]['id'])
                                .toList()
                                .first['is_upvoted'];
                          } else {
                            alreadyVote = null;
                          }

                          if (isVoted) {
                            Map data = votesBloc
                                .where((e) =>
                                    e['id_comment'] ==
                                    widget.comments[widget.idx]['id'])
                                .toList()
                                .first;
                            if (data['is_upvoted'] == false) {
                              alreadyVote = false;
                              return FaIcon(
                                FontAwesomeIcons.chevronDown,
                                size: 20,
                                color: Colors.grey[500],
                              );
                            }
                          }

                          return GestureDetector(
                            onTap: doUnvote,
                            child: FaIcon(
                              FontAwesomeIcons.chevronDown,
                              size: 20,
                              color: Colors.purple,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    widget.comments[widget.idx]['text'].trim(),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
