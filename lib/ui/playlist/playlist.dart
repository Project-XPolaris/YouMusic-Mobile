import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';

class PlaylistModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, provider, child) {
      return Container(
        color: Colors.black,
        height: 720,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 16),
              child: Container(
                child: Text("Playlist",style: TextStyle(color:Colors.pink,fontSize: 20),),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
                child: ListView(
                  children: provider.playerService.assetsAudioPlayer.playlist.audios.map((e) => InkWell(
                    splashColor: Colors.pink,
                    focusColor: Colors.pink,
                    onTap: (){},
                    child: Container(
                      height: 48,
                      child: Row(
                        children: [
                          Text(e.metas.title,style: TextStyle(color:Colors.white,fontSize: 16))
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
