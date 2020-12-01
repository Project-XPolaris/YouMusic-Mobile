import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/components/item_music_list.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/music.dart';
import 'package:youmusic_mobile/ui/music-list/provider.dart';
import 'package:youmusic_mobile/utils/listview.dart';

class MusicListPage extends StatelessWidget {
  final Map<String, String> extraFilter;

  const MusicListPage({Key key, this.extraFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MusicListProvider>(
        create: (_) => MusicListProvider(extraFilter: extraFilter),
        child: Consumer<MusicListProvider>(builder: (context, provider, child) {
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            provider.loadData();
            var _controller = createLoadMoreController(provider.loadMore);
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text(
                  "Music List",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
              ),
              body: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: ListView(
                  controller: _controller,
                  children: provider.loader.list.map((music) {
                    return ListTile(
                      title: Text(
                        music.title + " - " + music.getArtistString(""),
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(music.getAlbumName("Unknown"),
                          style:
                              TextStyle(color: Colors.white54, fontSize: 12)),
                      leading: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          music.getCoverUrl(),
                          fit: BoxFit.cover,
                        ),
                      ),
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
              bottomNavigationBar: PlayBar(),
            );
          });
        }));
  }
}
