import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/blocs/auth_bloc.dart';
import 'package:unord/blocs/education_bloc.dart';
import 'package:unord/blocs/liked_notes_bloc.dart';
import 'package:unord/blocs/subject_bloc.dart';
import 'package:unord/blocs/user_bloc.dart';
import 'package:unord/helpers/database_helper.dart';
import 'package:unord/helpers/network_helper.dart';

class MainService extends DatabaseHelper {
  Future<void> boot() async {
    await getLikedNote();
    await getEducations();
    await getSubjects();
  }

  Future<void> getSubjects() async {
    Response response =
        await NetworkHelper().get('subjects');

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
    Response response =
        await NetworkHelper().get('educations');

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
    Response response =
        await NetworkHelper().get('note-likes?user.id=$userId');

    List<Map> data = response.data
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

  bool isAuthenticated() {
    var token = box.get('access_token', defaultValue: null);
    var userData = box.get('user_data', defaultValue: null);

    return token != null && userData != null;
  }

  bool registerBloc() {
    try {

      var token = box.get('access_token', defaultValue: null);
      var userData = box.get('user_data', defaultValue: null);
      List<Map> likedNotes =
          box.get('liked_notes', defaultValue: []).cast<Map>();

      Modular.get<AuthBloc>().add(token);
      Modular.get<UserBloc>().add(userData);
      Modular.get<LikedNotesBloc>().add(likedNotes);
    } catch (e) {
      return false;
    }

    return true;
  }
}
