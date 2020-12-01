import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/components/item_music.dart';
import 'package:youmusic_mobile/ui/home/tabs/all/provider.dart';
import 'package:youmusic_mobile/ui/meta-navigation/music.dart';
import 'package:youmusic_mobile/utils/listview.dart';

class AllTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MusicTabProvider>(
        create: (_) => MusicTabProvider(),
        child: Consumer<PlayProvider>(builder: (context, playProvider, child) {
          return Consumer<MusicTabProvider>(
              builder: (context, provider, child) {
            var controller =
                createLoadMoreController(() => provider.loadMore());
            provider.loadData();
            return Center(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: GridView.count(
                    controller: controller,
                    childAspectRatio: 9 / 13,
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: provider.loader.list.map((e) {
                      return MusicItem(
                          music: e,
                          onTap: (music) {
                            playProvider.playMusic(music,autoPlay: true);
                          },
                          onLongPress: (music) {
                            HapticFeedback.selectionClick();
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => MusicMetaInfo(
                                      music: music,
                                    ));
                          });
                    }).toList(),
                  ),
                ),
              ),
            );
          });
        }));
  }
}
