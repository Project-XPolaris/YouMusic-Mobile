import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/components/item_artist.dart';
import 'package:youmusic_mobile/ui/home/tabs/artist/provider.dart';

class ArtistTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArtistTabProvider>(
        create: (_) => ArtistTabProvider(),
        child: Consumer<ArtistTabProvider>(builder: (context, provider, child) {
          provider.loadData();
          return Center(
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: GridView.count(
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
