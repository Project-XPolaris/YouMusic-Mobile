import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/config.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/play/play.dart';

class PlayBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, provider, child) {
      return Container(
        height: 72,
        color: Color(0xFF2B2B2B),
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: provider.currentMusic == null
              ? buildEmptyView()
              : buildMusicView(context,provider),
        ),
      );
    });
  }

  Container buildEmptyView() {
    return Container(
      child: Center(
        child: Text(
          "nothing to play",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  getPlayIcon(PlayStatus status){
    switch(status){
      case PlayStatus.Play:
        return Icons.pause;
      case PlayStatus.Pause:
        return Icons.play_arrow;
    }
  }
  Row buildMusicView(BuildContext context,PlayProvider playProvider) {
    String cover = "";
    if (playProvider.currentMusic.album != null){
      cover = ApplicationConfig.apiUrl + playProvider.currentMusic.album.cover;
    }
    String artist = "unknown";
    if (playProvider.currentMusic.artist != null && playProvider.currentMusic.artist.length != 0){
      artist = playProvider.currentMusic.artist.map((e) => e.name).join("/");
    }
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayPage()),
            );
          },
          child:AspectRatio(
            aspectRatio: 1,
            child: Container(
              child: Image.network(cover),
            ),
          ) ,
        ),
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playProvider.currentMusic.title,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      softWrap: false,
                    ),
                    Text(
                      artist,
                      style: TextStyle(color: Colors.white70),
                      softWrap: false,
                    )
                  ]),
            ),
          ),
        ),
        Container(
          child: Center(
            child: IconButton(
              icon: Icon(
                getPlayIcon(playProvider.playStatus),
                size: 28,
                color: Colors.white,
              ),
              onPressed: () async {
                // print("hit!!!!!!!!!!!");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => PlayPage()),
                // );
                if (playProvider.playStatus == PlayStatus.Play) {
                  print("will pause");
                  playProvider.pausePlay();
                  return;
                }
                if (playProvider.playStatus == PlayStatus.Pause) {
                  print("wiil play");
                  playProvider.resumePlay();
                  return;
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
