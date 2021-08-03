import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}

var bleuclair = HexColor('A2B8D4');
var bleufonce = HexColor('0E4CA7');
var orange = HexColor("F26B5B");
var noirecrit = HexColor('2F3435');
var blancfond = HexColor("F1EEE6");
