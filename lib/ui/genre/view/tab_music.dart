import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/components/music-list.dart';

import '../../../provider/provider_play.dart';
import '../../../utils/listview.dart';
import '../bloc/genre_bloc.dart';

class GenreTabMusic extends StatelessWidget {
  const GenreTabMusic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenreBloc, GenreState>(
      builder: (context, state) {
        return Consumer<PlayProvider>(builder: (context, playProvider, child) {
          var controller = createLoadMoreController(() =>
              context.read<GenreBloc>().add(LoadMoreMusicEvent()));
          return RefreshIndicator(
            onRefresh: () async {
              context.read<GenreBloc>().add(LoadMusicEvent(force: true));
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
        });
      },
    );
  }
}
