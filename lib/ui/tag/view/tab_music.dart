import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/components/music-list.dart';

import '../../../provider/provider_play.dart';
import '../../../utils/listview.dart';
import '../bloc/tag_bloc.dart';

class TagTabMusic extends StatelessWidget {
  const TagTabMusic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, playProvider, child) {
      return BlocBuilder<TagBloc, TagState>(
        builder: (context, state) {
          var controller = createLoadMoreController(() =>
              BlocProvider.of<TagBloc>(context).add(LoadMoreMusicEvent()));
          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<TagBloc>(context)
                  .add(MusicFilterUpdatedEvent(state.musicFilter));
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: MusicList(
                controller: controller,
                list: state.musicList,
                onTap: (e) {
                  playProvider.playMusic(e, autoPlay: true);
                },
              ),
            ),
          );
        },
      );
    });
  }
}
