import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        textSelectionHandleColor: Colors.black,
        textSelectionColor: Colors.white,
        primaryColor: Colors.blue,
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        textSelectionHandleColor: Colors.white,
        textSelectionColor: Colors.black,
      );
}
