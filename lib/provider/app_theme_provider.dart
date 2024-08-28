import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeMode appTheme = ThemeMode.dark;
  SharedPreferences? prefs;

  void changeTheme(ThemeMode newMode) {
    if (appTheme == newMode) {
      return;
    }
    appTheme = newMode;
    setThemeToCash(newMode);

    notifyListeners();
  }

  bool isDarkMode() {
    return appTheme == ThemeMode.dark;
  }

  Future setThemeToCash(ThemeMode newMode) async {
    prefs = await SharedPreferences.getInstance();
    String themeName = newMode == ThemeMode.light ? 'light' : 'dark';

    await prefs!.setString('theme', themeName);
  }

  loadTheme() async {
    prefs = await SharedPreferences.getInstance();
    final String? themeName = prefs!.getString('theme');
    if (themeName != null) {
      appTheme = themeName == 'light' ? ThemeMode.light : ThemeMode.dark;
      notifyListeners();
    }
  }
}
