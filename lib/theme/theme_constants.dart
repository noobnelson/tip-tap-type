import 'package:flutter/material.dart';

const color1 = Color.fromARGB(255, 179, 179, 179);
const color2 = Color.fromRGBO(11, 83, 81, 1);
const color3 = Color.fromRGBO(145, 245, 173, 1);
const color4 = Color.fromRGBO(78, 128, 152, 1);
const color5 = Color.fromRGBO(144, 194, 231, 1);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: color1,
  scaffoldBackgroundColor: color3,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: color5,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(color4),
      fixedSize: MaterialStatePropertyAll(Size.fromWidth(1000)),
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          fontSize: 30,
          color: Colors.amber,
        )
      ),
      //textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 50, color: color3)),
    )
  ),
  navigationRailTheme: NavigationRailThemeData(
    backgroundColor: color2,
    selectedIconTheme: IconThemeData(color: color3),
    unselectedIconTheme: IconThemeData(color: color1),
    selectedLabelTextStyle: TextStyle(color: color3),
    unselectedLabelTextStyle: TextStyle(color: color1),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: color2, 
      fontWeight: FontWeight.bold,
      fontSize: 50,
    ),
    headlineMedium: TextStyle(color: color2, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: color4),
    titleMedium: TextStyle(color: color2),
    labelLarge: TextStyle(color: color3, fontSize: 30),
  ),
  listTileTheme: ListTileThemeData(
    subtitleTextStyle: TextStyle(),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);