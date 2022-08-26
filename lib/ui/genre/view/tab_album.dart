import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../utils/listview.dart';
import '../../album/album.dart';
import '../../components/album-filter.dart';
import '../../components/item_album.dart';
import '../../meta-navigation/album.dart';
import '../bloc/genre_bloc.dart';

class GenreTabAlbum extends StatelessWidget {
  const GenreTabAlbum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenreBloc, GenreState>(
      builder: (context, state) {
        var controller = createLoadMoreController(() =>
            context.read<GenreBloc>().add(LoadMoreAlbumEvent()));
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<GenreBloc>().add(LoadAlbumEvent(force: true));
            },
            child: GridView.count(
              physics: AlwaysScrollableScrollPhysics(),
              controller: controller,
              childAspectRatio: 9 / 13,
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: state.albumList.map((e) {
                return AlbumItem(
                  album: e,
                  onTap: (album) {
                    AlbumPage.launch(context, album.id, cover: album
                        .getCoverUrl(), blurHash: album.blurHash);
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
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
