import 'package:shared_preferences/shared_preferences.dart';

class SharedFunctions {
  // UID

  static String sharedPreferencesUIDKey = "USERuid";
  static Future<bool> saveUserUid(String uid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(sharedPreferencesUIDKey, uid);
      return true;
    } catch (e) {
      print("error saving uid to shared preferences");
      return false;
    }
  }

  static Future<String> getUserUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesUIDKey);
  }

  // Email

  static String sharedPreferencesEmailKey = "USERemail";
  static Future<bool> saveUserEmail(String email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(sharedPreferencesEmailKey, email);
      return true;
    } catch (e) {
      print("error saving email to shared preferences");
      return false;
    }
  }

  static Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesEmailKey);
  }

  // name

  static String sharedPreferencesNameKey = "USERname";
  static Future<bool> saveUserName(String name) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(sharedPreferencesNameKey, name);
      return true;
    } catch (e) {
      print("error saving name to shared preferences");
      return false;
    }
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesNameKey);
  }

  // is admin?
  // true --> admin
  // false --> not admin

  static String sharedPreferencesAdminKey = "USERadmin";
  static Future<bool> saveUserAdminStatus(bool adminStatus) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(sharedPreferencesAdminKey, adminStatus);
      return true;
    } catch (e) {
      print("error saving admin status to shared preferences");
      return false;
    }
  }

  static Future<bool> getUserAdminStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferencesAdminKey);
  }
}
