import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCatatanBloc extends Bloc<String, String> {
  @override
  String get initialState => '';

  @override
  Stream<String> mapEventToState(String event) async* {
    yield event;
  }
}
