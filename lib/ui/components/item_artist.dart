import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';

class ArtistItem extends StatelessWidget {
  final Artist artist;
  final Function(Artist) onTap;
  final Function(Artist) onLongPress;

  const ArtistItem({Key key, this.artist, this.onTap, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 200,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (onTap != null) {
                onTap(artist);
              }
            },
            onLongPress: () {
              if (onLongPress != null) {
                onLongPress(artist);
              }
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: artist.getAvatarUrl() == null?Container(
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 48,
                    ),
                  ),
                ):Image(
                  image: NetworkImage(artist.getAvatarUrl()),
                  fit: BoxFit.cover,
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
                      artist.name,
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
