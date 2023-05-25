import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

// these colors need to change the match the theme color
const Map<int, Color> primarySwatch = {
  50: Color.fromRGBO(255, 207, 68, .1),
  100: Color.fromRGBO(255, 207, 68, .2),
  200: Color.fromRGBO(255, 207, 68, .3),
  300: Color.fromRGBO(255, 207, 68, .4),
  400: Color.fromRGBO(255, 207, 68, .5),
  500: Color.fromRGBO(255, 207, 68, .6),
  600: Color.fromRGBO(255, 207, 68, .7),
  700: Color.fromRGBO(255, 207, 68, .8),
  800: Color.fromRGBO(255, 207, 68, .9),
  900: Color.fromRGBO(255, 207, 68, 1),
};
const MaterialColor primaryColor = MaterialColor(0xFFFFCF44, primarySwatch);
const int primaryColorDark = 0xFF2798A5;
const int primaryLightTeal = 0xFF8CC3CC;
const int primaryDarkTeal = 0xFF007182;
const int primaryRegularTeal = 0xFF44ABB9;

Color baseColor = const Color(primaryDarkTeal);
Color blueGreyColor = const Color(0xFF607D8B); // Example blue-grey color
double mixAmount = 0.2; // Adjust the mix amount as desired (0.0 to 1.0)

TinyColor tc = TinyColor.fromColor(Colors.black54);
int darkerThanPrimaryDarkTealColor = tc.mix(const Color(primaryDarkTeal), 40).color.value;


// npm intall aws@amplify;