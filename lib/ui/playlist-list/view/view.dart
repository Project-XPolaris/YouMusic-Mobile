import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/music-list/music_list.dart';
import 'package:youmusic_mobile/ui/playlist/view/view.dart';
import 'package:youmusic_mobile/utils/listview.dart';

import '../../../api/entites.dart';
import '../bloc/playlist_list_bloc.dart';

class PlaylistListPage extends StatelessWidget {
  final Map<String, String> extraFilter;
  const PlaylistListPage({Key? key,this.extraFilter = const{}}) : super(key: key);

  static launch(BuildContext context,
      {Map<String, String> extraFilter = const {}, String? title}) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlaylistListPage(extraFilter: extraFilter,)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaylistListBloc(extraFilter: extraFilter)..add(new LoadEvent()),
      child: BlocBuilder<PlaylistListBloc, PlaylistListState>(
        builder: (context, state) {
          ScrollController _controller = createLoadMoreController(
              () => context.read<PlaylistListBloc>().add(new LoadMoreEvent()));
          return Scaffold(
            appBar: AppBar(
              title: Text("Playlist"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
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
                          PlaylistPage.launch(context, playlist);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)));
                  },
                ),
              ),
            ),
            bottomNavigationBar: PlayBar(),
          );
        },
      ),
    );
  }
}
