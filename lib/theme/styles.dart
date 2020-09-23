import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        textSelectionHandleColor: Colors.black,
        textSelectionColor: Colors.white,
        primaryColor: Color(0xFFBC3686),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        textSelectionHandleColor: Colors.white,
        textSelectionColor: Colors.black,
      );
}
