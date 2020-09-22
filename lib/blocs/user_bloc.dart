import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:unord/data/constants.dart';

class UserBloc extends Bloc<Map, Map> {
  @override
  Map get initialState =>
      Hive.box(boxName).get('user_data', defaultValue: null);

  @override
  Stream<Map> mapEventToState(Map event) async* {
    yield event;
  }
}
