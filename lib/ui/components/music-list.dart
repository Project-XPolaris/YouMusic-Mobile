import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youmusic_mobile/utils/time.dart';

import '../../api/entites.dart';
import '../meta-navigation/music.dart';

class MusicList extends StatelessWidget {
  final ScrollController? controller;
  final List<Music> list;
  final Function(Music)? onTap;

  const MusicList({Key? key, this.controller, required this.list, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: controller,
      children: list.map((music) {
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
            music.title ?? "Unknown",
            style: TextStyle(),
          ),
          subtitle: Text(music.getArtistString("unknown"), style: TextStyle()),
          onTap: () => onTap?.call(music),
          onLongPress: () {
            HapticFeedback.selectionClick();
            showModalBottomSheet(
                context: context,
                builder: (context) => MusicMetaInfo(
                      music: music,
                    ));
          },
          contentPadding: EdgeInsets.only(left: 8, right: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          trailing: Text(
            formatDuration(Duration(seconds: music.duration?.toInt() ?? 0)),
            style: TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
    );
  }
}
