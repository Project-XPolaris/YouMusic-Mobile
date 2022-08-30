import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/artist-list/provider.dart';
import 'package:youmusic_mobile/ui/artist/view/artist.dart';
import 'package:youmusic_mobile/ui/components/artist-list-item.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/artist.dart';
import 'package:youmusic_mobile/utils/listview.dart';

import '../../event.dart';
import '../../event/artist.dart';
import '../components/artist-filter.dart';

class ArtistListPage extends StatelessWidget {
  final Map<String, String> extraFilter;
  final String title;
  const ArtistListPage({Key? key, this.extraFilter = const {},this.title = "Artist List"}) : super(key: key);
  static launch(BuildContext context, {Map<String, String> extraFilter = const {},
    String? title}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArtistListPage(
              extraFilter: extraFilter,
              title: title ?? "Artist List",
            )));
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArtistListProvider>(
        create: (_) => ArtistListProvider(extraFilter: extraFilter),
        child: Consumer<ArtistListProvider>(builder: (context, provider, child) {
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            provider.loadData();
            var _controller = createLoadMoreController(provider.loadMore);
            EventBusManager.instance.eventBus.on<ArtistFollowChangeEvent>().listen((event) {
              if (!event.isFollow){
                provider.onUnFollow(event.artistId);
              }
            });
            _onFilterButtonClick() {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return ArtistFilterView(
                      filter: provider.artistFilter,
                      onChange: (filter) {
                        provider.artistFilter = filter;
                        if (_controller.hasClients && _controller.offset > 0) {
                          _controller.jumpTo(0);
                        }
                        provider.loadData(force: true);
                      },
                    );
                  });
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                      icon: Icon(Icons.sort), onPressed: _onFilterButtonClick)
                ],
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: RefreshIndicator(
                  onRefresh: ()async{
                    await provider.loadData(force: true);
                  },
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    children:provider.loader.list.map((artist) {
                      return Container(
                        padding: EdgeInsets.only(bottom: 8),
                        child: ArtistListItem(artist: artist,),
                      );
                    }).toList(),
                  ),
                ),
              ),
              bottomNavigationBar: PlayBar(),
            );
          });
        }));
  }
}
