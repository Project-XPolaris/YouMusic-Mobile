import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/components/item_artist.dart';
import 'package:youmusic_mobile/ui/home/tabs/artist/provider.dart';
import 'package:youmusic_mobile/utils/listview.dart';

class ArtistTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArtistTabProvider>(
        create: (_) => ArtistTabProvider(),
        child: Consumer<ArtistTabProvider>(builder: (context, provider, child) {
          provider.loadData();
          var controller = createLoadMoreController(() => provider.loadMore());
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
                    return ArtistItem(artist: e,);
                  }).toList(),
                ),
              ),
            ),
          );
        }
        )
    );
  }
}
