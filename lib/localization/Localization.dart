import 'package:flutter/material.dart';

class Internationalization {
  static final all = [
    Locale('en'),
    Locale('he'),
  ];

  static String toLanguageName(String code) {
    switch (code) {
      case 'he':
        return 'Hebrew';
      case 'en':
      default:
        return 'English';
    }
  }
}
