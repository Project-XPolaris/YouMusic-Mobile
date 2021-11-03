import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';

class ArtistItem extends StatelessWidget {
  final Artist artist;
  final Function(Artist)? onTap;
  final Function(Artist)? onLongPress;

  const ArtistItem(
      {Key? key, required this.artist, this.onTap, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var coverUrl = artist.getAvatarUrl();
    return Container(
      width: 110,
      height: 200,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap?.call(artist);
              }
            },
            onLongPress: () {
              if (onLongPress != null) {
                onLongPress?.call(artist);
              }
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: coverUrl == null
                    ? Container(
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: coverUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                Icon(Icons.music_note_rounded),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
              ),
            ),
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
                      artist.name ?? "Unknown",
                      style: TextStyle(color: Colors.white),
                      softWrap: false,
                    ),
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
