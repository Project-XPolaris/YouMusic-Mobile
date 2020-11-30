import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitPage extends StatelessWidget {
  final Function onRefresh;

  const InitPage({Key key, this.onRefresh}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _apiUrlInputController = TextEditingController();
    _onFinishClick()async{
      print(_apiUrlInputController.text);
      var pref = await SharedPreferences.getInstance();
      pref.setString("apiUrl", _apiUrlInputController.text);
      onRefresh();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(

            children: [
              Container(
                margin: EdgeInsets.only(),
                child: Text(
                  "YouMusic",
                  style: TextStyle(color: Colors.pink, fontSize: 48),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 72),
                child: Text(
                  "from ProjectXPolaris",
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              Text(
                "在首次使用时需要一定的配置",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
              Container(
                margin: EdgeInsets.only(top: 32),
                child: TextField(
                  controller: _apiUrlInputController,
                  style: TextStyle(color:Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white
                          )
                      ),
                      focusColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: '服务端地址'),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FlatButton(
                          onPressed: _onFinishClick,
                          child: Text(
                            "完成",
                            style: TextStyle(color: Colors.pink),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
