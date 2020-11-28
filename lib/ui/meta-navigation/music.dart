import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album/album.dart';
import 'package:youmusic_mobile/ui/artist/artist.dart';
import 'package:youmusic_mobile/ui/meta-navigation/view.dart';

class MusicMetaInfo extends StatelessWidget {
  final Music music;

  const MusicMetaInfo({Key key, this.music}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, provider, child) {
      List<Widget> items = [MetaItem(title: "Play",icon: Icons.play_arrow,onTap:(){
        Navigator.pop(context);
        provider.playMusic(music);
      }),MetaItem(title: "Add to play",icon: Icons.playlist_add,onTap:(){
        Navigator.pop(context);
        provider.addMusicToPlayList(music);
      })];
      if (music.getAlbumName(null) != null){
        items.add(MetaItem(title: music.getAlbumName(""),icon: Icons.album,onTap:(){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AlbumPage(id: music.album.id,)),
          );
        }));
      }
      items.addAll(music.artist.map((artist) {
        return MetaItem(title: artist.name,icon: Icons.person,onTap:(){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ArtistPage(id: artist.id,)),
          );
        });
      }));
      return MetaNavigation(
        cover: music.getCoverUrl(),
        title: music.title,
        title2: music.getArtistString("Unknown"),
        title3: music.getAlbumName("Unknown"),
        items: items,
      );
    });
  }
}
