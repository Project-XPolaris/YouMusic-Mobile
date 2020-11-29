import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youmusic_mobile/index.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/init/init.dart';

import 'ui/home/home.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<PlayProvider>(
        create: (_) => PlayProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  UniqueKey refreshToken = UniqueKey();

  Future<bool> getSP() async {
    var pref = await SharedPreferences.getInstance();
    var apiUrl = pref.getString("apiUrl");
    return apiUrl == null || apiUrl == '';
  }

  reloadApp() {
    setState(() {
      refreshToken = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSP(),
      builder: (BuildContext context, AsyncSnapshot<bool> data) {
        if (data.hasData) {
          var view = data.data
              ? InitPage(onRefresh: () {
                  setState(() {
                    refreshToken = UniqueKey();
                  });
                })
              : IndexPage();

          return MaterialApp(
            title: 'YouMusic',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: view,
          );
        }
        return Container();
      },
    );
  }
}
