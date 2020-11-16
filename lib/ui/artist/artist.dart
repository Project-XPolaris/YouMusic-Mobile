import 'package:flutter/material.dart';

class ArtistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          height: 360,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text("Oasis",style: TextStyle(color: Colors.black,fontSize: 48,fontWeight: FontWeight.w700),),
            ),
          ),
        ),
        Container(
          color: Colors.black12,
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
            )
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
              children: [
                Container(
                  height: 240,
                ),
                Container(

                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
