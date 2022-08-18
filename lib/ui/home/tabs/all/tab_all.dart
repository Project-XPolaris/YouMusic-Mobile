import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/components/cache_image.dart';
import 'package:youmusic_mobile/ui/components/music-filter.dart';
import 'package:youmusic_mobile/ui/components/music-list.dart';
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
            _onFilterButtonClick(){
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return MusicFilterView(
                      filter: provider.musicFilter,
                      onChange: (filter) {
                        provider.musicFilter = filter;
                        if (controller.offset > 0){
                          controller.jumpTo(0);
                        }
                        provider.loadData(force: true);
                      },
                    );
                  });
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "YouMusic",
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(icon: Icon(Icons.sort), onPressed: _onFilterButtonClick)
                ],
              ),
              body: Container(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await provider.loadData(force: true);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: MusicList(
                      controller: controller,
                      list: provider.loader.list,
                      onTap: (e) {
                        playProvider.playMusic(e,autoPlay: true);
                      },
                    ),
                  ),
                ),
              ),
            );
          });
        }));
  }
}
