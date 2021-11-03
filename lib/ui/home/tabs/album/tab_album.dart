import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/album/album.dart';
import 'package:youmusic_mobile/ui/components/album-filter.dart';
import 'package:youmusic_mobile/ui/components/item_album.dart';
import 'package:youmusic_mobile/ui/home/tabs/album/provider.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/utils/listview.dart';

class AlbumTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlbumTabProvider>(
        create: (_) => AlbumTabProvider(),
        child: Consumer<AlbumTabProvider>(builder: (context, provider, child) {
          var controller = createLoadMoreController(() => provider.loadMore());
          provider.loadData();
          _onFilterButtonClick(){
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return AlbumFilterView(
                    filter: provider.albumFilter,
                    onChange: (filter) {
                      provider.albumFilter = filter;
                      if (controller.positions.isNotEmpty){
                        controller.jumpTo(0);
                      }
                      provider.loadData(force: true);
                    },
                  );
                });
          }
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                "YouMusic",
                style: TextStyle(color: Colors.pink),
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
                  child: GridView.count(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: controller,
                    childAspectRatio: 9 / 13,
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: provider.loader.list.map((e) {
                      return AlbumItem(
                        album: e,
                        onTap: (album) {
                          int? albumId = album.id;
                          if (albumId == null) {
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlbumPage(
                                      id: albumId,
                                    )),
                          );
                        },
                        onLongPress: (album) {
                          HapticFeedback.selectionClick();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => AlbumMetaInfo(
                                    album: album,
                                  ));
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
