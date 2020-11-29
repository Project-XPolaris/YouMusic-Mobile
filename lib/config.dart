import 'package:shared_preferences/shared_preferences.dart';

class ApplicationConfig {
  static final apiUrl = "http://192.168.31.193:3000";
  static final ApplicationConfig _singleton = ApplicationConfig._internal();
  String serviceUrl;

  factory ApplicationConfig() {
    return _singleton;
  }

  ApplicationConfig._internal();

  Future<bool> loadConfig() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    serviceUrl = sharedPreferences.getString("apiUrl");
    print("load config complete");
    return true;
  }
}
