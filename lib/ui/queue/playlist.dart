import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/utils/icons.dart';

class PlaylistModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, provider, child) {
      return StreamBuilder(
          stream: provider.assetsAudioPlayer.current,
          builder: (context, asyncSnapshot) {
            Playing? current = asyncSnapshot.data as Playing?;
            return Container(
              height: 720,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 16),
                          child: Container(
                            child: Text(
                              "Playlist",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: provider.assetsAudioPlayer.loopMode,
                          builder: (context, asyncSnapshot) {
                            LoopMode? loopMode =
                                asyncSnapshot.data as LoopMode?;
                            return Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: IconButton(
                                icon: Icon(
                                  getLoopIcon(loopMode),
                                ),
                                onPressed: () {
                                  provider.assetsAudioPlayer.toggleLoop();
                                },
                              ),
                            );
                          }),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: ListView.builder(
                        itemCount: provider
                                .assetsAudioPlayer.playlist?.audios.length ??
                            0,
                        itemBuilder: (context, index) {
                          Audio? audio = provider
                              .assetsAudioPlayer.playlist?.audios[index];
                          int currentIndex = 0;
                          if (current != null) {
                            currentIndex = current.index;
                          }
                          var coverUrl = audio?.metas.image?.path;
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (data) {
                              var id = audio?.metas.id;
                              if (id != null) {
                                provider.removeFromPlayList(index, id);
                              }
                            },
                            child: Container(
                              child: ListTile(
                                title: Text(
                                  audio?.metas.title ?? "",
                                  style: TextStyle(),
                                  softWrap: false,
                                ),
                                subtitle: Text(audio?.metas.album ?? "Unknown",
                                    style: TextStyle(fontSize: 12)),
                                leading: coverUrl != null
                                    ? AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.network(
                                          coverUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(),
                                dense: true,
                                onTap: () {
                                  provider.assetsAudioPlayer
                                      .playlistPlayAtIndex(index);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: currentIndex == index
                                      ? Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer
                                      : null),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          });
    });
  }
}
