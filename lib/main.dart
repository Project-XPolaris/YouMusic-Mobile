import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/init/init.dart';

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
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.white
    // ));
    return FutureBuilder(
      future: getSP(),
      builder: (BuildContext context, AsyncSnapshot<bool> data) {
        if (data.hasData) {
          return MaterialApp(
            title: 'YouMusic',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.pink,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.pink,
              brightness: Brightness.dark,
            ),
            home: InitPage(),
            themeMode: ThemeMode.system,
          );
        }
        return Container();
      },
    );
  }
}
