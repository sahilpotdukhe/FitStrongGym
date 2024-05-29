import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class UniversalVariables{
  static final Color appThemeColor = HexColor('C41532');
  static final Color colour1 = HexColor("D32249");
  static final Color color2 = HexColor("E22F60");
  static final Gradient appGradient = LinearGradient(
      colors: [colour1, color2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}