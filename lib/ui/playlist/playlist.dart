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
          builder: (context,asyncSnapshot){
            Playing current = asyncSnapshot.data;
            return Container(
              color: Colors.black,
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
                              style: TextStyle(color: Colors.pink, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: provider.assetsAudioPlayer.loopMode,
                          builder: (context, asyncSnapshot) {
                            LoopMode loopMode = asyncSnapshot.data;
                            return Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: IconButton(
                                icon: Icon(
                                  getLoopIcon(loopMode),
                                  color: Colors.white,
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
                        itemCount: provider.assetsAudioPlayer.playlist.audios.length,
                        itemBuilder: (context,index){
                          Audio audio = provider.assetsAudioPlayer.playlist.audios[index];
                          int currentIndex = 0;
                          if (current != null) {
                            currentIndex = current.index;
                          }
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (data){
                              provider.removeFromPlayList(index, audio.metas.id);
                            },
                            child: Container(
                              color: currentIndex == index?Colors.pink:null,
                              child: ListTile(
                                title: Text(audio.metas.title,style: TextStyle(color: Colors.white),softWrap: false,),
                                subtitle: Text(audio.metas.album,style: TextStyle(color: Colors.white54,fontSize: 12)),
                                leading: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.network(audio.metas.image.path,fit: BoxFit.cover,),
                                ),
                                dense: true,
                                onTap: (){
                                  provider.assetsAudioPlayer.playlistPlayAtIndex(index);
                                },
                              ),
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
