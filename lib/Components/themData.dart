import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.brown[400],
  scaffoldBackgroundColor: Colors.brown[200],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.brown[400],
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black54),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.brown,
      foregroundColor: Colors.white,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.brown,
    foregroundColor: Colors.white,
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: Colors.brown,
    labelTextStyle: WidgetStateProperty.all(TextStyle(color: Colors.white)),
    backgroundColor: Colors.brown[400],
    iconTheme: WidgetStateProperty.all(IconThemeData(color: Colors.white)),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white10,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white10,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white10,
      foregroundColor: Colors.white,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.white24,
    foregroundColor: Colors.white,
  ),
  iconTheme: IconThemeData(
    opacity: 1,
    color: Colors.black,
  ),
);
