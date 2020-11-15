import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/components/item_album.dart';
import 'package:youmusic_mobile/ui/home/tabs/album/provider.dart';
import 'package:youmusic_mobile/utils/listview.dart';

class AlbumTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlbumTabProvider>(
        create: (_) => AlbumTabProvider(),
        child: Consumer<AlbumTabProvider>(builder: (context, provider, child) {
          var controller = createLoadMoreController(() => provider.loadMore());
          provider.loadData();
          return Container(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: GridView.count(
                controller: controller,
                childAspectRatio: 9 / 13,
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: provider.loader.list.map((e) {
                  return AlbumItem(album: e);
                }).toList(),
              ),
            ),
          );
        }));
  }
}
