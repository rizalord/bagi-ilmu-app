import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/blocs/auth_bloc.dart';
import 'package:unord/blocs/user_bloc.dart';
import 'package:unord/helpers/database_helper.dart';

class AuthService extends DatabaseHelper {
  bool saveUserData(dynamic data) {
    try {
      box.put('access_token', data['jwt']);
      box.put('user_data', data['user']);

      Modular.get<AuthBloc>().add(data['jwt']);
      Modular.get<UserBloc>().add(data['user']);
    } catch (e) {
      return false;
    }

    return true;
  }
}
