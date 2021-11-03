import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/play/play.dart';
import 'package:youmusic_mobile/ui/playlist/playlist.dart';

class PlayBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, provider, child) {
      provider.loadHistory();
      return Container(
        height: 72,
        color: Color(0xFF2B2B2B),
        child: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: buildMusicView(context, provider),
        ),
      );
    });
  }

  Widget buildMusicView(BuildContext context, PlayProvider playProvider) {
    return StreamBuilder(
        stream: playProvider.assetsAudioPlayer.current,
        builder: (context, asyncSnapshot) {
          Playing? current = asyncSnapshot.data as Playing?;
          if (current == null) {
            return Container(
              child: Center(
                child: Text(
                  "Nothing to play",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
          playProvider.onCurrentChange(current);
          var coverUrl = current.audio.audio.metas.image?.path;
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
                    child: coverUrl != null ? Image.network(
                      coverUrl,
                      fit: BoxFit.cover,
                    ):Container(),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (d) {
                    var delta = d.primaryVelocity ?? 0;
                    if ( delta < 0) {
                      playProvider.assetsAudioPlayer.next();
                    }
                    if (delta > 0) {
                      playProvider.assetsAudioPlayer.previous();
                    }
                  },
                  child: Container(
                    color: Color(0xFF2B2B2B),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              current.audio.audio.metas.title ?? "Unknown",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              softWrap: false,
                            ),
                            Text(
                              current.audio.audio.metas.artist ?? "Unknown",
                              style: TextStyle(color: Colors.white70),
                              softWrap: false,
                            )
                          ]),
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: playProvider.assetsAudioPlayer.isPlaying,
                  builder: (context, asyncSnapshot) {
                    final bool? isPlaying = asyncSnapshot.data as bool?;
                    return isPlaying != null?Container(
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 28,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            playProvider.assetsAudioPlayer.playOrPause();
                          },
                        ),
                      ),
                    ):Container();
                  }),
              IconButton(
                icon: Icon(Icons.playlist_play, color: Colors.white),
                iconSize: 28,
                onPressed: () {
                  showModalBottomSheet(
                      context: context, builder: (context) => PlaylistModal());
                },
              ),
            ],
          );
        });
  }
}
