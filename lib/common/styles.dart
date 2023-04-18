import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFFFE3D04);
const Color secondaryColor = Color(0xFFDC2C02);
const Color onPrimaryColor = Color(0xFF000000);
const Color onSecondaryColor = Color(0xFF565656);
const Color splashColor = Color(0xFFFFF01E);
const Color pageColor = Color(0xFFFCFAF9);

final TextTheme myTextTheme = TextTheme(
  headline1: GoogleFonts.berkshireSwash(fontSize: 92, fontWeight: FontWeight.w300, letterSpacing: -1.5, color: Colors.white),
  headline2: GoogleFonts.berkshireSwash(fontSize: 57, fontWeight: FontWeight.w300, letterSpacing: -0.5, color: Colors.white),
  headline3: GoogleFonts.berkshireSwash(fontSize: 46, fontWeight: FontWeight.w400, color: Colors.white),
  headline4: GoogleFonts.berkshireSwash(fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: Colors.white),
  headline5: GoogleFonts.lato(fontSize: 40, fontWeight: FontWeight.w400, color: secondaryColor),
  headline6: GoogleFonts.lato(fontSize: 30, fontWeight: FontWeight.w500, color: secondaryColor),
  subtitle1: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w400),
  subtitle2: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w500),
  bodyText1: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25,),
  button: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5,),
);
