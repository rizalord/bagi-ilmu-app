import 'package:flutter_bloc/flutter_bloc.dart';

class CatatanRefreshBloc extends Bloc<bool, bool> {
  @override
  bool get initialState => false;

  @override
  Stream<bool> mapEventToState(bool event) async* {
    yield event;
  }
}
