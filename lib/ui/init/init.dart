import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/ui/home/home.dart';
import 'package:youmusic_mobile/utils/login_history.dart';
import 'package:youplusauthplugin/youplusauthplugin.dart';

import '../../config.dart';

class InitPage extends StatefulWidget {
  const InitPage() : super();

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  Youplusauthplugin plugin = new Youplusauthplugin();
  String inputUrl = "";
  String inputUsername = "";
  String inputPassword = "";
  String loginMode = "history";

  @override
  Widget build(BuildContext context) {
    _onAuthComplete(String username, String token) async {
      var serviceUrl = ApplicationConfig().serviceUrl;
      if (serviceUrl == null) {
        return;
      }
      ApplicationConfig().token = token;
      LoginHistoryManager().add(LoginHistory(
          apiUrl: serviceUrl,
          username: username,
          token: token));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }

    Future<bool> _init() async {
      await LoginHistoryManager().refreshHistory();
      plugin.registerAuthCallback((username, token) {
        _onAuthComplete(username, token);
      });
      return true;
    }

    bool _applyUrl() {
      if (inputUrl.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("please input service url")));
        return false;
      }
      var uri;
      try {
        uri = Uri.parse(inputUrl);
      } on FormatException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("input service url invalidate")));
        return false;
      }
      if (!uri.hasScheme) {
        inputUrl = "http://" + inputUrl;
      }
      if (!uri.hasPort) {
        inputUrl += ":3000";
      }
      ApplicationConfig().serviceUrl = inputUrl;
      return true;
    }

    _onFinishClick() async {
      if (!_applyUrl()) {
        return;
      }
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("apiUrl", inputUrl);
      await ApplicationConfig().loadConfig();
      var info = await ApiClient().fetchInfo();
      if (inputUsername.isEmpty && inputPassword.isEmpty) {
        // without login
        ApplicationConfig().token = "";
        ApplicationConfig().username = "public";
        LoginHistoryManager()
            .add(LoginHistory(apiUrl: inputUrl, username: "public", token: ""));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        return;
      }
      // login with account
      String? authUrl = info.authUrl;
      if (authUrl == null) {
        return;
      }
      Dio dio = new Dio();
      var response = await dio.post(authUrl, data: {
        "username": inputUsername,
        "password": inputPassword,
      });
      if (response.data["success"]) {
        ApplicationConfig().token = response.data["token"];
        ApplicationConfig().username = inputUsername;
        LoginHistoryManager().add(LoginHistory(
            apiUrl: inputUrl,
            username: inputUsername,
            token: response.data["token"]));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
          future: _init(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(),
                        child: Text(
                          "YouMusic",
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 48,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 64),
                        child: Text(
                          "from ProjectXPolaris",
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     TextButton(
                      //         onPressed: () {
                      //           setState(() {
                      //             loginMode = "history";
                      //           });
                      //         },
                      //         child: Text(
                      //           "LoginHistory",
                      //           style: TextStyle(
                      //               color: loginMode == "history"
                      //                   ? Colors.white
                      //                   : Colors.white54,
                      //               fontSize: 28,
                      //               fontWeight: FontWeight.w300),
                      //         )),
                      //     TextButton(
                      //         onPressed: () {
                      //           setState(() {
                      //             loginMode = "new";
                      //           });
                      //         },
                      //         child: Text(
                      //           "New Login",
                      //           style: TextStyle(
                      //             color: loginMode == "new"
                      //                 ? Colors.white
                      //                 : Colors.white54,
                      //             fontSize: 28,
                      //             fontWeight: FontWeight.w300,
                      //           ),
                      //         ))
                      //   ],
                      // ),
                      Expanded(
                          child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 16),
                              child: TabBar(
                                indicatorColor: Colors.pink,
                                tabs: [
                                  Tab(
                                    text: "History",
                                  ),
                                  Tab(
                                    text: "New login",
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: TabBarView(
                              physics: BouncingScrollPhysics(),
                              children: [
                                ListView(
                                  children:
                                      LoginHistoryManager().list.map((history) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        onTap: () {
                                          var config = ApplicationConfig();
                                          config.token = history.token;
                                          config.serviceUrl = history.apiUrl;
                                          config.username = history.username;
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()));
                                        },
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.pink,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(
                                          history.username ?? "Public",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          history.apiUrl,
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                ListView(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: TextField(
                                        style: TextStyle(color: Colors.white),
                                        cursorColor: Colors.pink,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pink, width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white24,
                                                width: 1.0),
                                          ),
                                          labelText: "URL",
                                          labelStyle:
                                              TextStyle(color: Colors.white54),
                                        ),
                                        onChanged: (text) {
                                          setState(() {
                                            inputUrl = text;
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: TextField(
                                        style: TextStyle(color: Colors.white),
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pink, width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white24,
                                                width: 1.0),
                                          ),
                                          labelText: "Username",
                                          labelStyle:
                                              TextStyle(color: Colors.white54),
                                        ),
                                        onChanged: (text) {
                                          setState(() {
                                            inputUsername = text;
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: TextField(
                                        style: TextStyle(color: Colors.white),
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        obscureText: true,
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.pink, width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white24,
                                                width: 1.0),
                                          ),
                                          labelText: "Password",
                                          labelStyle:
                                              TextStyle(color: Colors.white54),
                                        ),
                                        onChanged: (text) {
                                          setState(() {
                                            inputPassword = text;
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(top: 16),
                                      child: ElevatedButton(
                                        child: Text(
                                          "Login",
                                          style: TextStyle(),
                                        ),
                                        onPressed: () {
                                          _onFinishClick();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.pink,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: TextButton(
                                        child: Text(
                                          "Login with YouPlus",
                                          style: TextStyle(color: Colors.pink),
                                        ),
                                        onPressed: () {
                                          if (!_applyUrl()) {
                                            return;
                                          }
                                          plugin.openYouPlus();
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              );
            }
            return Container();
          }),
    );
  }
}
