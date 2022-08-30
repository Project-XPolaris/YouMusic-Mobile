import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album/view/album.dart';
import 'package:youmusic_mobile/ui/artist/view/artist.dart';
import 'package:youmusic_mobile/ui/meta-navigation/view.dart';

class AlbumMetaInfo extends StatelessWidget {
  final Album album;

  const AlbumMetaInfo({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, provider, child) {
      return MetaNavigation(
        cover: album.getCoverUrl(),
        title: album.name ?? "",
        title2: album.getArtist("Unknown"),
        title3: "Album",
        items: [
          MetaItem(
            title: album.name ?? "",
            icon: Icons.album,
            onTap: () {
              Navigator.pop(context);
              AlbumPage.launch(context,album.id,cover: album.getCoverUrl(),blurHash: album.blurHash);
            },
          ),
          ...album.artist.map((artist) {
            return MetaItem(
              title: artist.name ?? "",
              icon: Icons.person,
              onTap: () {
                Navigator.pop(context);
                ArtistPage.launch(context, artist.id);
              },
            );
          }),
          MetaItem(
              title: "Play",
              icon: Icons.play_arrow,
              onTap: () {
                Navigator.pop(context);
                var albumId = album.id;
                if (albumId == null) {
                  return;
                }
                provider.playAlbum(albumId);
              }),
          MetaItem(
              title: "Add to playlist",
              icon: Icons.playlist_add,
              onTap: () {
                Navigator.pop(context);
                var albumId = album.id;
                if (albumId == null) {
                  return;
                }
                provider.addAlbumToPlaylist(albumId);
              })
        ],
      );
    });
  }
}
