import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/event.dart';
import 'package:youmusic_mobile/event/artist.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album-list/provider.dart';
import 'package:youmusic_mobile/ui/album/view/album.dart';
import 'package:youmusic_mobile/ui/components/album_grid.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/utils/listview.dart';

import '../components/album-filter.dart';

class AlbumListPage extends StatelessWidget {
  final Map<String, String> extraFilter;
  final String title;

  const AlbumListPage(
      {Key? key, this.extraFilter = const {}, this.title = "Album List"})
      : super(key: key);

  static launch(BuildContext context, {Map<String, String> extraFilter = const {},
      String? title}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AlbumListPage(
                  extraFilter: extraFilter,
                  title: title ?? "Album List",
                )));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlbumListProvider>(
        create: (_) => AlbumListProvider(extraFilter: extraFilter),
        child: Consumer<AlbumListProvider>(builder: (context, provider, child) {

          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            provider.loadData();
            var _controller = createLoadMoreController(provider.loadMore);
            _onFilterButtonClick(){
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return AlbumFilterView(
                      filter: provider.albumFilter,
                      onChange: (filter) {
                        provider.albumFilter = filter;
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
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(title),
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(icon: Icon(Icons.sort), onPressed: _onFilterButtonClick)
                ],
              ),
              body: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await provider.loadData(force: true);
                  },
                  child: AlbumGrid(
                    controller: _controller,
                    albums: provider.loader.list,
                    onTap: (album) {
                      AlbumPage.launch(context, album.id,
                          cover: album.cover, blurHash: album.blurHash);
                    },
                    onLongPress: (album) {
                      HapticFeedback.selectionClick();
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => AlbumMetaInfo(
                                album: album,
                              ));
                    },
                  ),
                ),
              ),
              bottomNavigationBar: PlayBar(),
            );
          });
        }));
  }
}
