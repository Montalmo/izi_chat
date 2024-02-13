import 'package:flutter/material.dart';

abstract class PalletColors {
  static const Color cBG = Color.fromRGBO(22, 25, 30, 1);
  static const Color cBGContainer = Color.fromRGBO(25, 29, 34, 1);
  static const Color cWhite = Color.fromRGBO(255, 255, 255, 1);
  static const Color cGray = Color.fromRGBO(196, 203, 221, 1);
  static const Color cGrayText = Color.fromRGBO(151, 151, 157, 1);
  static const Color cGrayField = Color.fromRGBO(32, 36, 43, 1);
  static const Color cCyan600 = Color.fromRGBO(4, 179, 239, 1);
}

abstract class PalletGradients {
  static const LinearGradient gCyan = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: <Color>[
      Color.fromRGBO(1, 120, 229, 1),
      Color.fromRGBO(4, 179, 239, 1),
      Color.fromRGBO(0, 223, 237, 1),
    ],
  );
}

abstract class PalletTextStyles {
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );
  static const TextStyle titleBig = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );
  static const TextStyle bodyBig = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );
}
