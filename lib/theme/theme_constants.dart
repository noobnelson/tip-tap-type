// ignore_for_file: prelightColor1fer_const_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

const lightColor1 = Color.fromARGB(255, 179, 179, 179);
const lightColor2 = Color.fromRGBO(11, 83, 81, 1);
const lightColor3 = Color.fromARGB(255, 88, 196, 118);
const lightColor4 = Color.fromARGB(255, 101, 142, 161);
const lightColor5 = Color.fromRGBO(144, 194, 231, 1);

const darkColor1 = Color.fromARGB(255, 179, 179, 179);
const darkColor2 = Color.fromARGB(255, 96, 96, 96);
const darkColor3 = Color.fromARGB(255, 0, 0, 0);
const darkColor4 = Color.fromARGB(255, 71, 75, 77);
const darkColor5 = Color.fromARGB(255, 140, 162, 180);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: lightColor1,
  scaffoldBackgroundColor: lightColor3,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: lightColor5,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(lightColor4),
      fixedSize: MaterialStatePropertyAll(Size.fromWidth(1000)),
    )
  ),
  navigationRailTheme: NavigationRailThemeData(
    backgroundColor: lightColor2,
    selectedIconTheme: IconThemeData(color: lightColor3),
    unselectedIconTheme: IconThemeData(color: lightColor1),
    selectedLabelTextStyle: TextStyle(color: lightColor3),
    unselectedLabelTextStyle: TextStyle(color: lightColor1),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: lightColor2, 
      fontWeight: FontWeight.bold,
      fontSize: 50,
    ),
    headlineMedium: TextStyle(color: lightColor2, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: lightColor4),
    titleMedium: TextStyle(color: lightColor2),
    labelLarge: TextStyle(color: lightColor3, fontSize: 30),
  ),
  listTileTheme: ListTileThemeData(
    subtitleTextStyle: TextStyle(),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
    primaryColor: darkColor1,
  scaffoldBackgroundColor: darkColor3,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: darkColor5,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(darkColor4),
      fixedSize: MaterialStatePropertyAll(Size.fromWidth(1000)),
    )
  ),
  navigationRailTheme: NavigationRailThemeData(
    backgroundColor: darkColor2,
    selectedIconTheme: IconThemeData(color: darkColor3),
    unselectedIconTheme: IconThemeData(color: darkColor1),
    selectedLabelTextStyle: TextStyle(color: darkColor3),
    unselectedLabelTextStyle: TextStyle(color: darkColor1),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: darkColor2, 
      fontWeight: FontWeight.bold,
      fontSize: 50,
    ),
    headlineMedium: TextStyle(color: darkColor2, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: darkColor4),
    titleMedium: TextStyle(color: darkColor2),
    labelLarge: TextStyle(color: darkColor3, fontSize: 30),
  ),
  listTileTheme: ListTileThemeData(
    subtitleTextStyle: TextStyle(),
  ),
);