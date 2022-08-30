import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/components/album_grid.dart';

import '../../utils/listview.dart';
import '../album/view/album.dart';
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
          child: AlbumGrid(
            albums: provider.albumLoader.list,
            controller: controller,
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
          ),
        ),
      );
    });

  }
}
