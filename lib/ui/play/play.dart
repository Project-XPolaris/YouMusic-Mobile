import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/play/slider.dart';
import 'package:youmusic_mobile/ui/playlist/playlist.dart';
import 'package:youmusic_mobile/utils/time.dart';

class PlayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getPlayIcon(PlayStatus status) {
      switch (status) {
        case PlayStatus.Play:
          return Icons.pause;
        case PlayStatus.Pause:
          return Icons.play_arrow;
      }
    }

    return Consumer<PlayProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Builder(
          builder: (buildContext){
            return Padding(
              padding: EdgeInsets.only(top: 32, left: 36, right: 36),
              child: Column(
                children: [
                  Container(
                    child: Image.network(provider.currentMusic.getCoverUrl()),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            provider.currentMusic.title,
                            style: TextStyle(
                                color: Colors.pinkAccent,
                                fontSize: 28,
                                fontWeight: FontWeight.w300),
                            softWrap: false,
                          ),
                        ),
                        Text(
                          provider.currentMusic.getArtistString("Unknown"),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                          softWrap: false,
                        ),
                        Text(
                          provider.currentMusic.getAlbumName("Unknown"),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                          softWrap: false,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    child: Column(
                      children: [
                        PlaySlider(),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder(
                                  stream: provider.playerService.assetsAudioPlayer
                                      .currentPosition,
                                  builder: (context, asyncSnapshot) {
                                    final Duration duration = asyncSnapshot.data;
                                    return Text(
                                      formatDuration(duration),
                                      style: TextStyle(color: Colors.white),
                                    );
                                  }),
                              StreamBuilder(
                                  stream: provider
                                      .playerService.assetsAudioPlayer.current,
                                  builder: (context, asyncSnapshot) {
                                    final Playing playing = asyncSnapshot.data;
                                    return Text(
                                      formatDuration(playing.audio.duration),
                                      style: TextStyle(color: Colors.white),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.loop,
                                color: Colors.white),
                            iconSize: 32,
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_previous_rounded,
                                color: Colors.white),
                            iconSize: 32,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: IconButton(
                              onPressed: () {
                                if (provider.playStatus == PlayStatus.Play) {
                                  provider.pausePlay();
                                  return;
                                }
                                if (provider.playStatus == PlayStatus.Pause) {
                                  print("wiil play");
                                  provider.resumePlay();
                                  return;
                                }
                              },
                              icon: Icon(
                                getPlayIcon(provider.playStatus),
                                color: Colors.pink,
                              ),
                              iconSize: 48,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_next, color: Colors.white),
                            iconSize: 32,
                          ),
                          IconButton(
                            icon: Icon(Icons.library_music_sharp, color: Colors.white),
                            iconSize: 32,
                            onPressed: (){
                              showModalBottomSheet(
                                  context: buildContext,
                                  builder: (context) => PlaylistModal());
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
