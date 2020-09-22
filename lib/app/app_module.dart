import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/blocs/auth_bloc.dart';
import 'package:unord/blocs/user_bloc.dart';
import 'package:unord/screens/auth/login_screen.dart';
import 'package:unord/screens/auth/register_screen.dart';
import 'package:unord/screens/auth/splash_screen.dart';
import 'package:unord/screens/tab/main_tab.dart';

import 'app_widget.dart';

class AppModule extends MainModule {

  @override
  List<Bind> get binds => [
    Bind((_) => AuthBloc()),
    Bind((_) => UserBloc()),
  ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter('/', child: (_, __) =>  SplashScreen()),
    ModularRouter('/login', child: (_, __) =>  LoginScreen()),
    ModularRouter('/register', child: (_, __) =>  RegisterScreen()),
    ModularRouter('/general', child: (_, __) =>  MainTab()),
  ];
  
  @override
  Widget get bootstrap => AppWidget();
}