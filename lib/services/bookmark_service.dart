import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/blocs/bookmark_bloc.dart';
import 'package:unord/helpers/database_helper.dart';
import 'package:unord/helpers/network_helper.dart';

class BookmarkService extends DatabaseHelper {
  Future<bool> bookmarkNote(int id) async {
    try {
      var userId = box.get('user_data')['id'];

      Response response = await NetworkHelper().post('bookmarks', {
        'user': userId,
        'bookmark_type': 1,
        'note': id,
        'pr': null,
        'course': null,
      });

      var bookmarkResponse = response.data;

      List<Map> bookmarks = box.get('bookmarks', defaultValue: []).cast<Map>();

      bookmarks.add(bookmarkResponse);

      box.put('bookmarks', bookmarks);

      Modular.get<BookmarkBloc>().add(bookmarks);
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> unbookmarkNote(int id) async {
    try {

      List<Map> bookmarks = box.get('bookmarks', defaultValue: []).cast<Map>();

      Map targetDelete = bookmarks
          .where((e) => e['bookmark_type']['id'] == 1 && e['note'] != null)
          .toList()
          .where((e) => e['note']['id'] == id)
          .toList()
          .first;

      await NetworkHelper()
          .delete('bookmarks/' + targetDelete['id'].toString());

      List<Map> newList =
          bookmarks.where((e) => e['id'] != targetDelete['id']).toList();

      box.put('bookmarks', newList);

      Modular.get<BookmarkBloc>().add(newList);
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> bookmarkDiskusi(int id) async {
    try {
      var userId = box.get('user_data')['id'];

      Response response = await NetworkHelper().post('bookmarks', {
        'user': userId,
        'bookmark_type': 2,
        'note': null,
        'pr': id,
        'course': null,
      });

      var bookmarkResponse = response.data;

      List<Map> bookmarks = box.get('bookmarks', defaultValue: []).cast<Map>();

      bookmarks.add(bookmarkResponse);

      box.put('bookmarks', bookmarks);

      Modular.get<BookmarkBloc>().add(bookmarks);
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> unbookmarkDiskusi(int id) async {
    try {

      List<Map> bookmarks = box.get('bookmarks', defaultValue: []).cast<Map>();

      Map targetDelete = bookmarks
          .where((e) => e['bookmark_type']['id'] == 2 && e['pr'] != null)
          .toList()
          .where((e) => e['pr']['id'] == id)
          .toList()
          .first;

      await NetworkHelper()
          .delete('bookmarks/' + targetDelete['id'].toString());

      List<Map> newList =
          bookmarks.where((e) => e['id'] != targetDelete['id']).toList();

      box.put('bookmarks', newList);

      Modular.get<BookmarkBloc>().add(newList);
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> bookmarkVideo(int id) async {
    try {
      var userId = box.get('user_data')['id'];

      Response response = await NetworkHelper().post('bookmarks', {
        'user': userId,
        'bookmark_type': 3,
        'note': null,
        'pr': null,
        'course': id,
      });

      var bookmarkResponse = response.data;

      List<Map> bookmarks = box.get('bookmarks', defaultValue: []).cast<Map>();

      bookmarks.add(bookmarkResponse);

      box.put('bookmarks', bookmarks);

      Modular.get<BookmarkBloc>().add(bookmarks);
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> unbookmarkVideo(int id) async {
    try {

      List<Map> bookmarks = box.get('bookmarks', defaultValue: []).cast<Map>();

      Map targetDelete = bookmarks
          .where((e) => e['bookmark_type']['id'] == 3 && e['course'] != null)
          .toList()
          .where((e) => e['course']['id'] == id)
          .toList()
          .first;

      await NetworkHelper()
          .delete('bookmarks/' + targetDelete['id'].toString());

      List<Map> newList =
          bookmarks.where((e) => e['id'] != targetDelete['id']).toList();

      box.put('bookmarks', newList);

      Modular.get<BookmarkBloc>().add(newList);
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }
}
