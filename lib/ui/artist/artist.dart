import 'package:flutter/material.dart';
import 'package:youmusic_mobile/config.dart';

class ArtistPage extends StatefulWidget {
  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  var headAlpha = 0;
  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (pixel + 25 <= 255){
        setState(() {
          headAlpha = pixel.toInt() + 25;
        });
      }
      print(pixel);
    });

    return Stack(
      children: [
        Container(
          color: Colors.white,
          height: 360,
          width: double.infinity,
          // child: Center(
          //   child: Padding(
          //     padding: EdgeInsets.all(16),
          //   ),
          // ),

        ),
        Container(
          color: Colors.black.withAlpha(headAlpha),
          height: 360,
        ),
        Container(
          height: 360,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end:Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black
                ], // red to yellow
              ),
            ),
          child: Stack(
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 16,right: 16),
            child: ListView(
              controller: _controller,
              children: [

                Container(
                  height: 220,
                ),
                Text("Artist",style: TextStyle(color: Colors.white,fontSize: 32),textAlign: TextAlign.center,),
                Container(
                    height: 1024,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
