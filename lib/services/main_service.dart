import 'package:unord/helpers/database_helper.dart';

class MainService extends DatabaseHelper {
  void boot() {}

  bool isAuthenticated() {
    var token = box.get('access_token', defaultValue: null);
    var userData = box.get('user_data', defaultValue: null);

    return token != null && userData != null;
  }
}
