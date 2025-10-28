import 'package:shared_preferences/shared_preferences.dart';

class ThemePref {
  static const themeKey = 'theme_mode';

  Future<void> saveTheme(bool isLightMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isLightMode);
  }

  Future<bool> loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey) ?? true; // Default to light theme
  }
}
