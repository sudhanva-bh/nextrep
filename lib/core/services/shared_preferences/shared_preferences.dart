import 'package:shared_preferences/shared_preferences.dart';

class AuthPrefs {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _apiKey = 'gemini_api_key';

  /// SETS the login state to true.
  static Future<void> hasLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
  }

  /// SETS the login state to false and DELETES the stored API key.
  static Future<void> hasLoggedOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_apiKey); // Also deletes the API key on logout
  }

  /// GETS the current login state.
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Saves the Gemini API key.
  static Future<void> saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKey, key);
  }

  /// Retrieves the stored Gemini API key.
  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKey);
  }

  /// Deletes only the API key, without affecting login state.
  static Future<void> clearApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKey);
  }
}
