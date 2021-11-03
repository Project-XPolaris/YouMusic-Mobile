import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';

class AlbumListItem extends StatelessWidget {
  final Album album;
  final bool showArtist;

  const AlbumListItem({Key? key, required this.album, this.showArtist = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var coverUrl = album.getCoverUrl();
    return Container(
      child: Row(
        children: [
          coverUrl != null
              ? Container(
                  width: 64,
                  child: Image.network(coverUrl),
                )
              : Container(
                  width: 64,
                  height: 64,
                  color: Colors.pink,
                  child: Center(
                    child: Icon(Icons.album,color: Colors.white,),
                  ),
                ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Text(
                      album.name ?? "Unknown",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    album.getArtist("Unknown"),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
