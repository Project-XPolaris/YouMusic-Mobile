import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/config.dart';

class AlbumItem extends StatelessWidget {
  final Album album;
  final Function(Album)? onTap;
  final Function(Album)? onLongPress;
  const AlbumItem({Key? key, required this.album, this.onTap, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var artist = "unknown";
    if (album.artist.isNotEmpty) {
      artist = album.artist.map((e) => e.name).join("/");
    }
    var coverUrl = album.getCoverUrl();
    return Container(
      width: 110,
      height: 200,
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
                onTap?.call(album);
            },
            onLongPress: (){
                onLongPress?.call(album);
            },
            child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: coverUrl != null ?CachedNetworkImage(
                    imageUrl: coverUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, downloadProgress) => Icon(Icons.music_note_rounded),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ):Container(
                    child: Center(
                      child: Icon(
                        Icons.music_note,
                        size: 48,
                      ),
                    ),
                  ),
                )),
          ),
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
                      album.name ?? "Unknown",
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
