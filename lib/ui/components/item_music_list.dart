import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/config.dart';

class MusicListItem extends StatelessWidget {
  final Music music;
  final bool showArtist;
  final bool showAlbum;
  const MusicListItem({Key? key, required this.music, this.showAlbum = true, this.showArtist = true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var cover = music.getCoverUrl();
    return Container(
      child: Row(
        children: [
          cover != null ?Container(
            width: 64,
            child: Image.network(cover),
          ):Container(
            child: Center(
              child: Icon(
                Icons.music_note,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(music.title ?? "Unknown",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                  Text(music.getArtistString("Unknown"),style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w300),),
                  Text(music.getAlbumName("Unknown"),style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w300),),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
