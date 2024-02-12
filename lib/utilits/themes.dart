import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izipizi_chat/utilits/pallets.dart';

final ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(4, 179, 239, 1),
    foregroundColor: PalletColors.cWhite,
    textStyle: PalletTextStyles.titleMedium,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        14.0,
      ),
    ),
    fixedSize: const Size(
      280.0,
      48.0,
    ),
  ),
);

const AppBarTheme appBarTheme = AppBarTheme(
  titleTextStyle: PalletTextStyles.bodyMedium,
  centerTitle: true,
  backgroundColor: PalletColors.cBG,
  surfaceTintColor: PalletColors.cBG,
  systemOverlayStyle: SystemUiOverlayStyle(
    systemNavigationBarColor: PalletColors.cBG,
    statusBarColor: PalletColors.cBG,
  ),
);

const ColorScheme colorScheme = ColorScheme.dark(
  primary: PalletColors.cCyan600,
  onPrimary: PalletColors.cWhite,
  onSurface: PalletColors.cWhite,
  background: PalletColors.cBG,
);

final InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 18.0,
    vertical: 18.0,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14.0),
    borderSide: const BorderSide(
      color: PalletColors.cGray,
    ),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14.0),
    borderSide: const BorderSide(
      width: 4,
      color: PalletColors.cGray,
    ),
  ),
);
