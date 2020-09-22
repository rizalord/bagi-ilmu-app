//  app_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/blocs/auth_bloc.dart';
import 'package:unord/blocs/user_bloc.dart';
import 'package:unord/theme/styles.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => Modular.get<AuthBloc>()),
        BlocProvider<UserBloc>(create: (context) => Modular.get<UserBloc>()),
      ],
      child: MaterialApp(
        initialRoute: "/",
        navigatorKey: Modular.navigatorKey,
        onGenerateRoute: Modular.generateRoute,
        themeMode: ThemeMode.light,
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
      ),
    );
  }
}
