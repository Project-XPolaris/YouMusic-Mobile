import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/music-list/provider.dart';
import 'package:youmusic_mobile/utils/listview.dart';

import '../components/music-filter.dart';
import '../components/music-list.dart';

class MusicListPage extends StatelessWidget {
  final Map<String, String> extraFilter;
  final String title;
  const MusicListPage({Key? key, this.extraFilter = const {},this.title = "Music List"}) : super(key: key);
  static launch(BuildContext context, {Map<String, String> extraFilter =const  {},String title = "Music List"}) {

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MusicListPage(
               extraFilter: extraFilter,
                title: title,
              )),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MusicListProvider>(
        create: (_) => MusicListProvider(extraFilter: extraFilter),
        child: Consumer<MusicListProvider>(builder: (context, provider, child) {
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            provider.loadData();
            var _controller = createLoadMoreController(provider.loadMore);
            _onFilterButtonClick(){
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return MusicFilterView(
                      filter: provider.filter,
                      onChange: (filter) {
                        provider.filter = filter;
                        if (_controller.hasClients && _controller.offset > 0){
                          _controller.jumpTo(0);
                        }
                        provider.loadData(force: true);
                      },
                    );
                  });
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  title,
                ),
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(onPressed: _onFilterButtonClick, icon: Icon(Icons.filter_alt_rounded))
                ],
              ),
              body: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: MusicList(
                  controller: _controller,
                  list: provider.loader.list,
                  onTap: (e) {
                    playProvider.playMusic(e,autoPlay: true);
                  },
                ),
              ),
              bottomNavigationBar: PlayBar(),
            );
          });
        }));
  }
}
