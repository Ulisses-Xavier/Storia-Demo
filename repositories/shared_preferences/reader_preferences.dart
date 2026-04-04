import 'package:shared_preferences/shared_preferences.dart';

class ReaderPreferences {
  static const _fontSizeKey = 'font_size';
  static const _themeKey = 'reader_theme';
  static const _fontFamilyKey = 'font_family';

  static Future<void> setFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }

  static Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontSizeKey) ?? 16.0;
  }

  static Future<void> setTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? true;
  }

  static Future<void> setFontFamily(String font) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamilyKey, font);
  }

  static Future<String> getFontFamily() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fontFamilyKey) ?? 'Poppins';
  }
}
