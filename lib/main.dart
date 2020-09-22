import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unord/data/constants.dart';

import 'app/app_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive..init((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox(boxName);

  runApp(ModularApp(module: AppModule()));
}
