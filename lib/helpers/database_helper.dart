import 'package:hive/hive.dart';
import 'package:unord/data/constants.dart';

abstract class DatabaseHelper {
  DatabaseHelper() {
    box = Hive.box(boxName);
  }

  Box box;
}