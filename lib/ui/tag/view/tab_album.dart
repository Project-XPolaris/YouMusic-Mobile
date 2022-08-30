import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youmusic_mobile/ui/components/album_grid.dart';

import '../../../utils/listview.dart';
import '../../album/view/album.dart';
import '../../meta-navigation/album.dart';
import '../bloc/tag_bloc.dart';

class TagTabAlbum extends StatelessWidget {
  const TagTabAlbum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagBloc, TagState>(
      builder: (context, state) {
        var controller = createLoadMoreController(() =>
            BlocProvider.of<TagBloc>(context).add(LoadMoreAlbumEvent()));
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<TagBloc>(context)
                  .add(AlbumFilterUpdatedEvent(state.albumFilter));
            },
            child: AlbumGrid(
              albums: state.albumList,
              controller: controller,
              onTap: (album) {
                AlbumPage.launch(
                    context, album.id, cover: album.getCoverUrl(),
                    blurHash: album.blurHash);
              },
              onLongPress: (album) {
                HapticFeedback.selectionClick();
                showModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        AlbumMetaInfo(
                          album: album,
                        ));
              },
            ),
          ),
        );
      },
    );
  }
}
