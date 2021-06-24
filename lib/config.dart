import 'package:shared_preferences/shared_preferences.dart';

class ApplicationConfig {
  static final ApplicationConfig _singleton = ApplicationConfig._internal();
  String serviceUrl;
  String token;
  String username;
  factory ApplicationConfig() {
    return _singleton;
  }

  ApplicationConfig._internal();

  Future<bool> loadConfig() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    serviceUrl = sharedPreferences.getString("apiUrl");
    return true;
  }
}
