import 'package:flutter/material.dart';

import '../../api/entites.dart';
import '../album/view/album.dart';
import 'item_album.dart';

class AlbumGrid extends StatelessWidget {
  final ScrollController? controller;
  final List<Album> albums;
  final Function(Album)? onTap;
  final Function(Album)? onLongPress;

  const AlbumGrid({Key? key,this.controller,this.albums = const [],this.onTap,this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: AlwaysScrollableScrollPhysics(),
      controller: controller,
      childAspectRatio: 9 / 13,
      crossAxisCount: MediaQuery.of(context).size.width ~/ 120,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: albums.map((e) {
        return AlbumItem(
          album: e,
          onTap: onTap,
          onLongPress: onLongPress,
        );
      }).toList(),
    );
  }
}
