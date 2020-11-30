import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/play/slider.dart';
import 'package:youmusic_mobile/ui/playlist/playlist.dart';
import 'package:youmusic_mobile/utils/icons.dart';
import 'package:youmusic_mobile/utils/time.dart';

class PlayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return Consumer<PlayProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: provider.assetsAudioPlayer.current,
          builder: (context,asyncSnapshot){
            Playing current = asyncSnapshot.data;
            return Builder(
              builder: (buildContext){
                return Padding(
                  padding: EdgeInsets.only(top: 16, left: 36, right: 36),
                  child: Column(
                    children: [
                      Container(
                        width: 360,
                        height: 360,
                        child: Image.network(current.audio.audio.metas.image.path),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
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
                            Container(
                              height: 48,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    current.audio.audio.metas.title,
                                    style: TextStyle(
                                        color: Colors.pinkAccent,
                                        fontSize: 28,),
                                    softWrap: false,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 32,
                              child: Text(
                                current.audio.audio.metas.artist,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300),
                                softWrap: false,
                              ),
                            ),
                            Container(
                              height: 32,
                              child: Text(
                                current.audio.audio.metas.album,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300),
                                softWrap: false,
                              ),
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
                                      stream: provider.assetsAudioPlayer
                                          .currentPosition,
                                      builder: (context, asyncSnapshot) {
                                        final Duration duration = asyncSnapshot.data;
                                        return Text(
                                          formatDuration(duration),
                                          style: TextStyle(color: Colors.white),
                                        );
                                      }),
                                  StreamBuilder(
                                      stream: provider.assetsAudioPlayer.current,
                                      builder: (context, asyncSnapshot) {
                                        final Playing playing = asyncSnapshot.data;
                                        return Text(
                                          formatDuration(playing.audio.audio.metas.extra["duration"]),
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
                              StreamBuilder(
                                  stream: provider.assetsAudioPlayer.loopMode,
                                  builder:(context, asyncSnapshot){
                                    LoopMode loopMode = asyncSnapshot.data;
                                    return IconButton(
                                      icon: Icon(getLoopIcon(loopMode),
                                          color: Colors.white),
                                      iconSize: 32,
                                      onPressed: (){
                                        provider.assetsAudioPlayer.toggleLoop();
                                      },
                                    );
                                  }
                              ),
                              IconButton(
                                icon: Icon(Icons.skip_previous_rounded,
                                    color: Colors.white),
                                iconSize: 32,
                                onPressed: (){
                                  provider.assetsAudioPlayer.previous();
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                child: StreamBuilder(
                                  stream: provider.assetsAudioPlayer.isPlaying,
                                  builder: (context, asyncSnapshot){
                                    final bool isPlaying = asyncSnapshot.data;
                                    return Container(
                                      child: IconButton(
                                            icon: Icon(
                                              isPlaying ? Icons.pause : Icons.play_arrow,
                                              color: Colors.pink,
                                            ),
                                            onPressed: () async {
                                              provider.assetsAudioPlayer
                                                  .playOrPause();
                                            },
                                            iconSize: 48,
                                          ),
                                    );
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.skip_next, color: Colors.white),
                                iconSize: 32,
                                onPressed: (){
                                  provider.assetsAudioPlayer.next();
                                },
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
            );
          },
        ),
      );
    });
  }
}
