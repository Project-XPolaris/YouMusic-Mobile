import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../utils/listview.dart';
import '../album/album.dart';
import '../components/album-filter.dart';
import '../components/item_album.dart';
import '../meta-navigation/album.dart';
import 'provider.dart';

class TagTabAlbum extends StatelessWidget {
  const TagTabAlbum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TagProvider>(builder: (context, provider, child) {
      var controller = createLoadMoreController(() => provider.loadMoreAlbums());

      return Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: RefreshIndicator(
          onRefresh: () => provider.forceReloadAlbum(),
          child: GridView.count(
            physics: AlwaysScrollableScrollPhysics(),
            controller: controller,
            childAspectRatio: 9 / 13,
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: provider.albumLoader.list.map((e) {
              return AlbumItem(
                album: e,
                onTap: (album) {
                  AlbumPage.launch(context, album.id, cover: album.getCoverUrl(),blurHash: album.blurHash);
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
      );
    });

  }
}
