import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';

class MusicItem extends StatelessWidget {
  final Music music;
  final Function(Music) onTap;
  final Function(Music) onLongPress;

  const MusicItem({Key key, this.music, this.onTap, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(music);
        }
      },
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress(music);
        }
      },
      child: Container(
        width: 110,
        height: 200,
        child: Column(
          children: [
            AspectRatio(
                aspectRatio: 1,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: music.getCoverUrl() != null
                      ? Image(
                          image: NetworkImage(music.getCoverUrl()),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          child: Center(
                            child: Icon(
                              Icons.music_note,
                              size: 48,
                            ),
                          ),
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
                      Text(
                        music.title,
                        style: TextStyle(color: Colors.white),
                        softWrap: false,
                      ),
                      Text(
                        music.getArtistString("Unknown"),
                        style: TextStyle(color: Colors.white54),
                        softWrap: false,
                      )
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
