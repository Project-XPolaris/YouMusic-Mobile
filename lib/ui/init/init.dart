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
    return Center(
      child: LoginLayout(
        onLoginSuccess: (loginAccount) {
          ApplicationConfig().serviceUrl = loginAccount.apiUrl;
          ApplicationConfig().token = loginAccount.token;
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        title: "YouMusic",
        subtitle: "ProjectXPolaris",
      ),
    );
  }
}
