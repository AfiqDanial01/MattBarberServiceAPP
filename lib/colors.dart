import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFE2E2E1),
  100: Color(0xFFB7B7B5),
  200: Color(0xFF888784),
  300: Color(0xFF585653),
  400: Color(0xFF34322E),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF0E0C08),
  700: Color(0xFF0C0A06),
  800: Color(0xFF090805),
  900: Color(0xFF050402),
});
const int _primaryPrimaryValue = 0xFF100E09;

const MaterialColor primaryAccent =
    MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFFF4D4D),
  200: Color(_primaryAccentValue),
  400: Color(0xFFE60000),
  700: Color(0xFFCD0000),
});
const int _primaryAccentValue = 0xFFFF1A1A;
