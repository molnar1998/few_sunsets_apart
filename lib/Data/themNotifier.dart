import 'package:flutter/material.dart';
import '../Components/themData.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme;

  ThemeNotifier(this._currentTheme);

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    if (_currentTheme == lightTheme) {
      _currentTheme = darkTheme;
    } else {
      _currentTheme = lightTheme;
    }
    notifyListeners();
  }
}
