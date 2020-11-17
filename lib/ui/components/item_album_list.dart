import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';

class AlbumListItem extends StatelessWidget {
  final Album album;
  final bool showArtist;
  const AlbumListItem({Key key, this.album, this.showArtist = true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 64,
            child: Image.network(album.getCoverUrl()),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Text(album.name,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                  Text(album.getArtist("Unknown"),style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w300),),
                ],
              ),
            ),
          ),
          IconButton(icon: Icon(Icons.more_vert,color: Colors.white,),)
        ],
      ),
    );
  }
}
