import 'package:flutter/material.dart';

class ImageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/404.jpg',
      fit: BoxFit.cover,
    );
  }
}
