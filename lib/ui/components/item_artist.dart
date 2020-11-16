import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';

class ArtistItem extends StatelessWidget {
  final Artist artist;
  final Function(Artist) onTap;
  const ArtistItem({Key key, this.artist, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              if (onTap != null){
                onTap(artist);
              }
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                child: Center(
                  child: Icon(Icons.person, size: 48),
                ),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
