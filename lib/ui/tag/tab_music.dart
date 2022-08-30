import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/components/music-list.dart';

import '../../provider/provider_play.dart';
import '../../utils/listview.dart';
import '../album/view/album.dart';
import '../components/item_album.dart';
import '../meta-navigation/album.dart';
import '../meta-navigation/music.dart';
import 'provider.dart';

class TagTabMusic extends StatelessWidget {
  const TagTabMusic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, playProvider, child) {
      return Consumer<TagProvider>(builder: (context, provider, child) {
        var controller = createLoadMoreController(() => provider.loadMoreMusics());
        return RefreshIndicator(
          onRefresh: () => provider.forceReloadMusic(),
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: MusicList(
              controller: controller,
              list: provider.musicLoader.list,
              onTap: (e) {
                playProvider.playMusic(e,autoPlay: true);
              },
            ),
          ),
        );
      });
    });
  }
}
