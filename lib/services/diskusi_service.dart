import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/blocs/liked_diskusi_bloc.dart';
import 'package:unord/blocs/voted_comment_bloc.dart';
import 'package:unord/helpers/database_helper.dart';
import 'package:unord/helpers/network_helper.dart';

class DiskusiService extends DatabaseHelper {
  Future<bool> like(int id) async {
    try {
      var userId = box.get('user_data')['id'];

      Response response = await NetworkHelper().post('pr-likes', {
        'pr': id,
        'user': userId,
      });

      var likeId = response.data['id'];

      List<Map> likedDiskusi =
          box.get('liked_diskusi', defaultValue: []).cast<Map>();

      likedDiskusi.add({
        'id_diskusi': id,
        'id_like': likeId,
      });

      box.put('liked_diskusi', likedDiskusi);

      Modular.get<LikedDiskusiBloc>().add(likedDiskusi);
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> unlike(int id) async {
    try {
      List<Map> likedDiskusi =
          box.get('liked_diskusi', defaultValue: []).cast<Map>();

      int idLike = likedDiskusi
          .where((element) => element['id_diskusi'] == id)
          .toList()
          .first['id_like'];

      await NetworkHelper().delete('pr-likes/$idLike');

      likedDiskusi =
          likedDiskusi.where((element) => element['id_diskusi'] != id).toList();

      box.put('liked_diskusi', likedDiskusi);

      Modular.get<LikedDiskusiBloc>().add(likedDiskusi);
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<bool> upvote(int idKomen) async {
    try {
      var userId = box.get('user_data')['id'];

      // Save to Server first
      Response response = await NetworkHelper().post('pr-vote-comments', {
        'pr_comment': idKomen,
        'user': userId,
        'isUpvoted': true,
      });

      // Save to local
      List<Map> votedComments =
          box.get('voted_comments', defaultValue: []).cast<Map>();

      votedComments.add({
        'id_comment': idKomen,
        'id_vote': response.data['id'],
        'is_upvoted': true,
      });

      box.put('voted_comments', votedComments);

      Modular.get<VotedCommentBloc>().add(votedComments);
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<bool> downvote(int idKomen) async {
    try {
      var userId = box.get('user_data')['id'];

      // Save to Server first
      Response response = await NetworkHelper().post('pr-vote-comments', {
        'pr_comment': idKomen,
        'user': userId,
        'isUpvoted': false,
      });

      // Save to local
      List<Map> votedComments =
          box.get('voted_comments', defaultValue: []).cast<Map>();

      votedComments.add({
        'id_comment': idKomen,
        'id_vote': response.data['id'],
        'is_upvoted': false,
      });

      box.put('voted_comments', votedComments);

      Modular.get<VotedCommentBloc>().add(votedComments);
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<void> deletePreviousVote(int idKomen) async {
    List<Map> votedComments =
        box.get('voted_comments', defaultValue: []).cast<Map>();

    bool isExist = votedComments
            .where((element) => element['id_comment'] == idKomen)
            .toList()
            .length >
        0;

    if (isExist) {
      int idVote = votedComments
          .where((element) => element['id_comment'] == idKomen)
          .toList()
          .first['id_vote'];
      await NetworkHelper().delete('pr-vote-comments/$idVote');
      votedComments = votedComments
          .where((element) => element['id_vote'] != idVote)
          .toList();

      box.put('voted_comments', votedComments);
      Modular.get<VotedCommentBloc>().add(votedComments);
    }
  }
}
