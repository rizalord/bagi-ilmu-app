import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/blocs/liked_notes_bloc.dart';
import 'package:unord/helpers/database_helper.dart';
import 'package:unord/helpers/network_helper.dart';

class NoteService extends DatabaseHelper {
  Future<bool> like(int id) async {
    try {
      var userId = box.get('user_data')['id'];

      Response response = await NetworkHelper().post('note-likes', {
        'note': id,
        'user': userId,
      });

      var likeId = response.data['id'];

      List<Map> likedNotes =
          box.get('liked_notes', defaultValue: []).cast<Map>();

      likedNotes.add({
        'id_catatan': id,
        'id_like': likeId,
      });

      box.put('liked_notes', likedNotes);

      Modular.get<LikedNotesBloc>().add(likedNotes);
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> unlike(int id) async {
    try {
      List<Map> likedNotes =
          box.get('liked_notes', defaultValue: []).cast<Map>();

      int idLike = likedNotes
          .where((element) => element['id_catatan'] == id)
          .toList()
          .first['id_like'];

      await NetworkHelper().delete('note-likes/$idLike');

      likedNotes =
          likedNotes.where((element) => element['id_catatan'] != id).toList();

      box.put('liked_notes', likedNotes);

      Modular.get<LikedNotesBloc>().add(likedNotes);
    } catch (e) {
      return false;
    }

    return true;
  }
}
