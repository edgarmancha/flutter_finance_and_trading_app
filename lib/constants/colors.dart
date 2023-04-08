import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

class GlobalColors {
  //#292826f1a07e
  static HexColor primaryColor = HexColor('#231F20');
  static HexColor boxColor = HexColor('#FFEDE5');
  static HexColor secondaryColor = HexColor('#D79F7F');
  static HexColor mainTextColor = HexColor('#292826');
  static HexColor buttonAccent = HexColor('#C1C0BE');
  static HexColor whiteAcc = HexColor('#FFFFFF');
  static HexColor thirdColor = HexColor('#32594A');
  static HexColor secodColor = HexColor('#5BB381');
  static HexColor message = HexColor('#262D3A');
  static const Color themeColor = Color(0xFF231F20);
}

class ThemeColors {
  static Color lightGrey = const Color(0xffE8E8E9);
  static Color black = const Color(0xff14121E);
  static Color grey = const Color(0xFF8492A2);
}

class ThemeStyles {
  static TextStyle primaryTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: ThemeColors.black,
  );
  static TextStyle seeAll = TextStyle(
    fontSize: 17.0,
    color: ThemeColors.black,
  );
  static TextStyle cardDetails = const TextStyle(
    fontSize: 17.0,
    color: Color(0xff66646d),
    fontWeight: FontWeight.w600,
  );
  static TextStyle cardMoney = const TextStyle(
    color: Colors.white,
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
  );
  static TextStyle tagText = TextStyle(
    fontStyle: FontStyle.italic,
    color: ThemeColors.black,
    fontWeight: FontWeight.w500,
  );
  static TextStyle otherDetailsPrimary = TextStyle(
    fontSize: 16.0,
    color: ThemeColors.black,
  );
  static TextStyle otherDetailsSecondary = const TextStyle(
    fontSize: 12.0,
    color: Colors.grey,
  );
}


//ConstrainedBox(
           //     constraints: const BoxConstraints(
//maxHeight: 60, maxWidth: double.infinity),#282725