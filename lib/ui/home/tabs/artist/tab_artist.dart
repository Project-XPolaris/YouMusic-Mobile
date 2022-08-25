import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/artist/artist.dart';
import 'package:youmusic_mobile/ui/components/artist-filter.dart';
import 'package:youmusic_mobile/ui/components/item_artist.dart';
import 'package:youmusic_mobile/ui/home/tabs/artist/provider.dart';
import 'package:youmusic_mobile/ui/meta-navigation/artist.dart';
import 'package:youmusic_mobile/utils/listview.dart';

import '../../../../api/entites.dart';

class ArtistTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArtistTabProvider>(
        create: (_) => ArtistTabProvider(),
        child: Consumer<ArtistTabProvider>(builder: (context, provider, child) {
          provider.loadData();
          var controller = createLoadMoreController(() => provider.loadMore());
          _onFilterButtonClick() {
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return ArtistFilterView(
                    filter: provider.artistFilter,
                    onChange: (filter) {
                      provider.artistFilter = filter;
                      if (controller.hasClients && controller.offset > 0) {
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
                IconButton(
                    icon: Icon(Icons.sort), onPressed: _onFilterButtonClick)
              ],
            ),
            body: Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await provider.loadData(force: true);
                },
                child: Padding(
                  padding: EdgeInsets.only(),
                  child: ListView.builder(
                      controller: controller,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final Artist artist = provider.loader.list[index];
                        return ListTile(
                          title: Text(artist.displayName),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            child: Icon(
                              Icons.person_rounded,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                          onTap: () {
                            ArtistPage.launch(context, artist.id);
                          },
                          onLongPress: () {
                            HapticFeedback.selectionClick();
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => ArtistMetaInfo(
                                      artist: artist,
                                    ));
                          },
                        );
                      },
                      itemCount: provider.loader.list.length,
                      padding: EdgeInsets.all(0)),
                ),
              ),
            ),
          );
        }));
  }
}
