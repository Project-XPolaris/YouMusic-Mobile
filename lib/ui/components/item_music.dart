import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';

class MusicItem extends StatelessWidget {
  final Music music;
  final Function(Music)? onTap;
  final Function(Music)? onLongPress;

  const MusicItem({Key? key, required this.music, this.onTap, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? cover = music.getCoverUrl();
    return GestureDetector(
      onTap: () {
        onTap?.call(music);
      },
      onLongPress: () {
        onLongPress?.call(music);
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
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: cover != null
                      ? CachedNetworkImage(
                          imageUrl: cover,
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
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      : Container(
                          child: Center(
                            child: Icon(
                              Icons.music_note,
                              size: 48,
                              color: Theme.of(context).colorScheme.onSecondary,
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
                        music.title ?? "Unknown",
                        softWrap: false,
                      ),
                      Text(
                        music.getArtistString("Unknown"),
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
