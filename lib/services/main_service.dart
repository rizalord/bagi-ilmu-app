import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/blocs/auth_bloc.dart';
import 'package:unord/blocs/bookmark_bloc.dart';
import 'package:unord/blocs/education_bloc.dart';
import 'package:unord/blocs/liked_diskusi_bloc.dart';
import 'package:unord/blocs/liked_notes_bloc.dart';
import 'package:unord/blocs/subject_bloc.dart';
import 'package:unord/blocs/user_bloc.dart';
import 'package:unord/blocs/voted_comment_bloc.dart';
import 'package:unord/helpers/database_helper.dart';
import 'package:unord/helpers/network_helper.dart';
import 'package:unord/services/auth_service.dart';

class MainService extends DatabaseHelper {
  Future<void> boot() async {
    await getLikedNote();
    await getLikedDiskusi();
    await getVotedComment();
    await getEducations();
    await getSubjects();
    await getBookmarks();
  }

  Future<void> getBookmarks() async {
    var userId = box.get('user_data')['id'];
    Response response = await NetworkHelper().get('bookmarks?user.id=$userId');

    List<Map> data = response.data.map((e) => e).toList().cast<Map>();

    box.put('bookmarks', data);
    Modular.get<BookmarkBloc>().add(data);
  }

  Future<void> getVotedComment() async {
    var userId = box.get('user_data')['id'];
    Response response =
        await NetworkHelper().get('pr-vote-comments?user.id=$userId');

    List<Map> data = response.data
        .where((e) => e['pr_comment'] != null)
        .map(
          (e) => {
            'id_comment': e['pr_comment']['id'],
            'id_vote': e['id'],
            'is_upvoted': e['isUpvoted'] == true
          },
        )
        .toList()
        .cast<Map>();

    box.put('voted_comments', data);
    Modular.get<VotedCommentBloc>().add(data);
  }

  Future<void> getSubjects() async {
    Response response = await NetworkHelper().get('subjects');

    List<Map> data = response.data
        .map(
          (e) => {
            'id': e['id'],
            'text': e['title'],
          },
        )
        .toList()
        .cast<Map>();

    Modular.get<SubjectBloc>().add(data);
  }

  Future<void> getEducations() async {
    Response response = await NetworkHelper().get('educations');

    List<Map> data = response.data
        .map(
          (e) => {
            'id': e['id'],
            'text': e['title'],
          },
        )
        .toList()
        .cast<Map>();

    Modular.get<EducationBloc>().add(data);
  }

  Future<void> getLikedNote() async {
    var userId = box.get('user_data')['id'];
    Response response = await NetworkHelper().get('note-likes?user.id=$userId');

    List<Map> data = response.data
        .where((e) => e['note'] != null)
        .map(
          (e) => {
            'id_catatan': e['note']['id'],
            'id_like': e['id'],
          },
        )
        .toList()
        .cast<Map>();

    box.put('liked_notes', data);
    Modular.get<LikedNotesBloc>().add(data);
  }

  Future<void> getLikedDiskusi() async {
    var userId = box.get('user_data')['id'];
    Response response = await NetworkHelper().get('pr-likes?user.id=$userId');

    List<Map> data = response.data
        .where((e) => e['pr'] != null)
        .map(
          (e) => {
            'id_diskusi': e['pr']['id'],
            'id_like': e['id'],
          },
        )
        .toList()
        .cast<Map>();

    box.put('liked_diskusi', data);
    Modular.get<LikedDiskusiBloc>().add(data);
  }

  bool isAuthenticated() {
    var token = box.get('access_token', defaultValue: null);
    var userData = box.get('user_data', defaultValue: null);

    return token != null && userData != null;
  }

  Future<bool> isExist() async {
    Response response = await NetworkHelper().get('users/me');

    if (response.data['statusCode'] != null) await AuthService().logout();

    return response.data['statusCode'] == null;
  }

  bool registerBloc() {
    try {
      var token = box.get('access_token', defaultValue: null);
      var userData = box.get('user_data', defaultValue: null);
      List<Map> likedNotes =
          box.get('liked_notes', defaultValue: []).cast<Map>();
      List<Map> likedDiskusi =
          box.get('liked_diskusi', defaultValue: []).cast<Map>();
      List<Map> votedComments =
          box.get('voted_comments', defaultValue: []).cast<Map>();
      List<Map> bookmarks = box.get('bookmarks', defaultValue: []).cast<Map>();

      Modular.get<AuthBloc>().add(token);
      Modular.get<UserBloc>().add(userData);
      Modular.get<LikedNotesBloc>().add(likedNotes);
      Modular.get<LikedDiskusiBloc>().add(likedDiskusi);
      Modular.get<VotedCommentBloc>().add(votedComments);
      Modular.get<BookmarkBloc>().add(bookmarks);
    } catch (e) {
      return false;
    }

    return true;
  }
}
