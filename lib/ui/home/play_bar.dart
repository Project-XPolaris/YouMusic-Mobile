import 'package:assets_audio_player/assets_audio_player.dart';
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
              : buildMusicView(context, provider),
        ),
      );
    });
  }

  Container buildEmptyView() {
    return Container(
      child: Center(
        child: Text(
          "Nothing to play",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildMusicView(BuildContext context, PlayProvider playProvider) {
    return StreamBuilder(
        stream: playProvider.playerService.assetsAudioPlayer.current,
        builder: (context, asyncSnapshot) {
          Playing current = asyncSnapshot.data;
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayPage()),
                  );
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    child: Image.network(current.audio.audio.metas.image.path),
                  ),
                ),
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
                            current.audio.audio.metas.title,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            softWrap: false,
                          ),
                          Text(
                            current.audio.audio.metas.artist,
                            style: TextStyle(color: Colors.white70),
                            softWrap: false,
                          )
                        ]),
                  ),
                ),
              ),
              StreamBuilder(
                  stream:
                      playProvider.playerService.assetsAudioPlayer.isPlaying,
                  builder: (context, asyncSnapshot) {
                    final bool isPlaying = asyncSnapshot.data;
                    return Container(
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 28,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            playProvider.playerService.assetsAudioPlayer
                                .playOrPause();
                          },
                        ),
                      ),
                    );
                  })
            ],
          );
        });
  }
}
