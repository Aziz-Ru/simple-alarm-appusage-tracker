import 'package:flutter/material.dart';

class Constants {
  static List<Widget> items = const [
    Icon(Icons.home, size: 30, color: Colors.white),
    Icon(
      Icons.alarm_add,
      size: 30,
      color: Colors.white,
    ),
    Icon(Icons.format_quote, size: 30, color: Colors.white),
  ];

  static String baseUrl = "https://zenquotes.io/api";
}
