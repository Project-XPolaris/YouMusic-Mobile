import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youmusic_mobile/ui/music-list/music_list.dart';
import 'package:youmusic_mobile/utils/listview.dart';

import '../../../api/entites.dart';
import '../bloc/playlist_list_bloc.dart';

class PlaylistListPage extends StatelessWidget {
  const PlaylistListPage({Key? key}) : super(key: key);

  static launch(BuildContext context,
      {Map<String, String> extraFilter = const {}, String? title}) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlaylistListPage()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaylistListBloc()..add(new LoadEvent()),
      child: BlocBuilder<PlaylistListBloc, PlaylistListState>(
        builder: (context, state) {
          ScrollController _controller = createLoadMoreController(
              () => context.read<PlaylistListBloc>().add(new LoadMoreEvent()));
          return Scaffold(
            appBar: AppBar(
              title: Text("Playlist"),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context
                    .read<PlaylistListBloc>()
                    .add(new LoadEvent(force: true));
                return;
              },
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: ListView.builder(
                  controller: _controller,
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    Playlist playlist = state.list[index];
                    return ListTile(
                        title: Text(state.list[index].displayName),
                        onTap: () {
                          MusicListPage.launch(context,
                              extraFilter: {"playlist": playlist.id.toString()},
                              title: playlist.displayName);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
