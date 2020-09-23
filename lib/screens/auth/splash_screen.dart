import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unord/services/main_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  navigate() {
    Future.delayed(Duration(seconds: 3), () {
      MainService().isAuthenticated()
          ? Modular.to.pushReplacementNamed('/general')
          : Modular.to.pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/images/splash_screen.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
