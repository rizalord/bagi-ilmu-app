import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

mixin URLs {
  static const String host = 'http://192.168.43.233:1337/';
}

mixin AppLimit {
  static const int REQUEST_TIME_OUT = 30000;
  static const int ALBUM_PAGE_SIZE = 18;
  static const int POST_PAGE_SIZE = 100;
}

const String sentryDSN = '';
const String appVersion = '0.0.1';
const String environment = 'Production';

const boxName = 'unord';

const availableSubject = [
  {
    'id': 1,
    'title': 'Matematika',
    'icon': FontAwesomeIcons.pencilRuler,
    'color': Color(0xFFFA694C),
  },
  {
    'id': 2,
    'title': 'B. Inggris',
    'icon': FontAwesomeIcons.amilia,
    'color': Color(0xFFFF9233),
  },
  {
    'id': 3,
    'title': 'B. Indonesia',
    'icon': FontAwesomeIcons.bookOpen,
    'color': Color(0xFF462066),
  },
  {
    'id': 4,
    'title': 'IPA',
    'icon': FontAwesomeIcons.balanceScale,
    'color': Color(0xFF8E3ED2),
  },
];
