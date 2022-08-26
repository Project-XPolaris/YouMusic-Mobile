import 'package:flutter/material.dart';

import '../../api/entites.dart';

class MusicListTileItem extends StatelessWidget {
  final Music music;
  final Function(Music)? onTap;
  final Function(Music)? onLongPress;

  const MusicListTileItem({Key? key, required this.music, this.onLongPress, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        child: ClipRRect(
          child: Center(
            child: Image.network(
              music.getCoverUrl() ?? "",
              fit: BoxFit.contain,
            ),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      title: Text(
        music.displayTitle,
        style: TextStyle(),
      ),
      subtitle: Text(music.getArtistString("unknown"), style: TextStyle()),
      onTap: () => onTap?.call(music),
      onLongPress: () => onLongPress?.call(music),
      contentPadding: EdgeInsets.only(left: 8, right: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
