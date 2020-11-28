import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album/album.dart';
import 'package:youmusic_mobile/ui/artist/artist.dart';
import 'package:youmusic_mobile/ui/meta-navigation/view.dart';

class AlbumMetaInfo extends StatelessWidget {
  final Album album;

  const AlbumMetaInfo({Key key, this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, provider, child) {
      return MetaNavigation(
        cover: album.getCoverUrl(),
        title: album.name,
        title2: album.getArtist("Unknown"),
        title3: "Album",
        items: [
          MetaItem(
            title: album.name,
            icon: Icons.album,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AlbumPage(
                          id: album.id,
                        )),
              );
            },
          ),
          ...album.artist.map((artist) {
            return MetaItem(
              title: artist.name,
              icon: Icons.person,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArtistPage(
                            id: artist.id,
                          )),
                );
              },
            );
          }),
          MetaItem(
              title: "Play",
              icon: Icons.play_arrow,
              onTap: () {
                Navigator.pop(context);
                provider.playAlbum(album.id);
              }),
          MetaItem(
              title: "Add to playlist",
              icon: Icons.playlist_add,
              onTap: () {
                Navigator.pop(context);
                provider.addAlbumToPlaylist(album.id);
              })
        ],
      );
    });
  }
}
