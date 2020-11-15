import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/config.dart';

class MusicItem extends StatelessWidget {
  final Music music;
  final Function(Music) onTap;
  const MusicItem({Key key, this.music, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String cover;
    if (music.album != null){
      cover = ApplicationConfig.apiUrl + music.album.cover;
    }

    String artist = "unknown";
    if (music.artist != null && music.artist.length != 0){
      artist = music.artist.map((e) => e.name).join("/");
    }
    return GestureDetector(
      onTap: (){
        if (onTap != null){
          onTap(music);
        }
      },
      child: Container(
        child: Column(
          children: [
            AspectRatio(
                aspectRatio: 1,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                  ),
                  child: Image(
                    image: NetworkImage(cover),
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Container(
                        child: Center(
                          child: Icon(
                            Icons.music_note,
                            size: 48,
                          ),
                        ),

                      );
                    },
                  ),
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(music.title,style: TextStyle(color: Colors.white),softWrap: false,),
                      Text(artist,style: TextStyle(color: Colors.white54),softWrap: false,)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
