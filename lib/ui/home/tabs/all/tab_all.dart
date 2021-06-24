import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/components/cache_image.dart';
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
            return Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await provider.loadData(force: true);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: ListView(
                    controller: controller,
                    children: provider.loader.list.map((music) {
                      return ListTile(
                        leading: Container(
                          width: 64,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CacheImage(url:music.getCoverUrl(),failedIcon: Icons.music_note,),
                          ),
                        ),
                        title: Text(music.title,style: TextStyle(color: Colors.white),),
                        subtitle: Text(music.getArtistString("unknown"),style: TextStyle(color: Colors.white70)),
                        onTap: () {
                          playProvider.playMusic(music,autoPlay: true);
                        },
                        onLongPress: () {
                          HapticFeedback.selectionClick();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => MusicMetaInfo(
                                music: music,
                              ));
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          });
        }));
  }
}
