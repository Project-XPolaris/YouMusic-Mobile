import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/artist/artist.dart';
import 'package:youmusic_mobile/ui/components/artist-filter.dart';
import 'package:youmusic_mobile/ui/components/item_artist.dart';
import 'package:youmusic_mobile/ui/home/tabs/artist/provider.dart';
import 'package:youmusic_mobile/ui/meta-navigation/artist.dart';
import 'package:youmusic_mobile/utils/listview.dart';

class ArtistTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArtistTabProvider>(
        create: (_) => ArtistTabProvider(),
        child: Consumer<ArtistTabProvider>(builder: (context, provider, child) {
          provider.loadData();
          var controller = createLoadMoreController(() => provider.loadMore());
          _onFilterButtonClick(){
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return ArtistFilterView(
                    filter: provider.artistFilter,
                    onChange: (filter) {
                      provider.artistFilter = filter;
                      if (controller.offset > 0){
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
                      return ArtistItem(
                          artist: e,
                          onTap: (artist) {
                            var artistId = e.id;
                            if (artistId == null) {
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArtistPage(
                                        id: artistId,
                                      )),
                            );
                          },
                          onLongPress: (artist) {
                            HapticFeedback.selectionClick();
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => ArtistMetaInfo(
                                      artist: artist,
                                    ));
                          });
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
