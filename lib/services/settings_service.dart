import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<void> saveThemeSettings(
      ThemeMode themeMode, String colorScheme, double fontSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode.toString());
    await prefs.setString('colorScheme', colorScheme);
    await prefs.setDouble('fontSize', fontSize);
  }

  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  Future<Settings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode');
    final languageCode = prefs.getString('languageCode');
    final colorScheme = prefs.getString('colorScheme');
    final fontSize = prefs.getDouble('fontSize');

    return Settings(
      themeMode: themeModeString == 'ThemeMode.dark'
          ? ThemeMode.dark
          : themeModeString == 'ThemeMode.light'
              ? ThemeMode.light
              : ThemeMode.system,
      languageCode: languageCode ?? 'en',
      colorScheme: colorScheme ?? 'Blue',
      fontSize: fontSize ?? 16.0,
    );
  }
}

class Settings {
  final ThemeMode themeMode;
  final String languageCode;
  final String colorScheme;
  final double fontSize;

  Settings({
    required this.themeMode,
    required this.languageCode,
    required this.colorScheme,
    required this.fontSize,
  });
}
