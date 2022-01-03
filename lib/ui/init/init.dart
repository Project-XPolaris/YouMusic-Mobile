import 'package:flutter/material.dart';
import 'package:youmusic_mobile/ui/home/home.dart';
import 'package:youui/layout/login/LoginLayout.dart';

import '../../config.dart';

class InitPage extends StatefulWidget {
  const InitPage() : super();

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    return LoginLayout(
      onLoginSuccess: (loginHistory) {
        ApplicationConfig().token = loginHistory.token;
        ApplicationConfig().serviceUrl = loginHistory.apiUrl;
        ApplicationConfig().username = loginHistory.username;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      },
      title: "YouMusic",
      subtitle: "ProjectXPolaris",
      backgroundColor: Colors.black,
      mainColor: Colors.pink,
      titleColor: Colors.pink,
      defaultPort: "3000",
      textColor: Colors.white,
      subtitleColor: Colors.white,
    );
  }
}
