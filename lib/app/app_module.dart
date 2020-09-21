import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/screens/LoginScreen.dart';
import 'package:unord/screens/SplashScreen.dart';

import 'app_widget.dart';

class AppModule extends MainModule {

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
    ModularRouter('/', child: (_, __) =>  SplashScreen()),
    ModularRouter('/login', child: (_, __) =>  LoginScreen()),
  ];
  
  @override
  Widget get bootstrap => AppWidget();
}