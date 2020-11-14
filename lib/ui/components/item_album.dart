import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/config.dart';

class AlbumItem extends StatelessWidget {
  final Album album;

  const AlbumItem({Key key, this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var artist = "unknown";
    if (album.artist.isNotEmpty) {
      artist = album.artist.map((e) => e.name).join("/");
    }
    return Container(
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
                  image: NetworkImage(ApplicationConfig.apiUrl + album.cover),
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
                    Text(
                      album.name,
                      style: TextStyle(color: Colors.white),
                      softWrap: false,
                    ),
                    Text(
                      artist,
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
    );
  }
}
