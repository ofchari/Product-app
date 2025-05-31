import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class SharedPrefsUtil {
  // Save login status
  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.loggedInKey, isLoggedIn);
  }

  // Get login status
  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Return false if the key doesn't exist
    return prefs.getBool(AppConstants.loggedInKey) ?? false;
  }
}
