import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/ui/album-list/album_list.dart';
import 'package:youmusic_mobile/ui/artist/view/artist.dart';
import 'package:youmusic_mobile/ui/meta-navigation/view.dart';
import 'package:youmusic_mobile/ui/music-list/music_list.dart';

class ArtistMetaInfo extends StatelessWidget {
  final Artist artist;

  const ArtistMetaInfo({Key? key, required this.artist}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MetaNavigation(
      cover: artist.getAvatarUrl(),
      title: artist.name ?? "Unknown",
      title2: "Artist",
      items: [
        MetaItem(title: artist.name ?? "Unknown",icon: Icons.person,onTap: (){
          Navigator.pop(context);
          ArtistPage.launch(context, artist.id);
        },),
        MetaItem(title: "All music",icon: Icons.music_note,onTap: (){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MusicListPage(
                  extraFilter: {
                    "artist": artist.id
                        .toString()
                  },
                )),
          );
        },),
        MetaItem(title: "All album",icon: Icons.album,onTap: (){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AlbumListPage(
                  extraFilter: {
                    "artist": artist.id
                        .toString()
                  },
                )),
          );
        },),
      ],
    );
  }
}
