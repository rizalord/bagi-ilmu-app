import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:unord/data/constants.dart';

class AuthBloc extends Bloc<String, String> {
  @override
  String get initialState =>
      Hive.box(boxName).get('access_token', defaultValue: null);

  @override
  Stream<String> mapEventToState(String event) async* {
    yield event;
  }
}
