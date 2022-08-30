
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album/view/album.dart';
import 'package:youmusic_mobile/ui/artist/view/artist.dart';
import 'package:youmusic_mobile/ui/meta-navigation/view.dart';

class MusicMetaInfo extends StatelessWidget {
  final Music music;

  const MusicMetaInfo({Key? key, required this.music}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, provider, child) {
      List<Widget> items = [MetaItem(title: "Play",icon: Icons.play_arrow,onTap:(){
        Navigator.pop(context);
        provider.playMusic(music,autoPlay: true);
      }),MetaItem(title: "Add to next play",icon: Icons.playlist_add,onTap:(){
        Navigator.pop(context);
        provider.addMusicToPlayList(music);
      })];
      var albumId = music.album?.id;
      if (albumId != null){
        items.add(MetaItem(title: music.getAlbumName(""),icon: Icons.album,onTap:(){
         AlbumPage.launch(context, albumId,cover: music.album?.getCoverUrl(),blurHash: music.album?.blurHash);
        }));
      }
      items.addAll(music.artist.map((artist) {
        return MetaItem(title: artist.name ?? "Unknown",icon: Icons.person,onTap:(){
          Navigator.pop(context);
          ArtistPage.launch(context, artist.id);
        });
      }));
      return MetaNavigation(
        cover: music.getCoverUrl(),
        title: music.title ?? "",
        title2: music.getArtistString("Unknown"),
        title3: music.getAlbumName("Unknown"),
        items: items,
      );
    });
  }
}
