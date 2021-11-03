import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _apiUrl = "";

  Future<bool> _loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, data) {
        if (data.hasData) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                "Setting",
                style: TextStyle(color: Colors.pink),
              ),
              backgroundColor: Colors.black,
            ),
            body: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.language, color: Colors.white),
                  title: Text(
                    "Reset Api URL",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    SharedPreferences sh =
                        await SharedPreferences.getInstance();
                    sh.setString("apiUrl", "");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("restart app to set new url"),
                    ));
                    MyAppState? myAppState = context.findRootAncestorStateOfType<MyAppState>();
                    myAppState?.reloadApp();
                  },
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
