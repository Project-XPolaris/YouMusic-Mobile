import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/components/music-list.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';

import '../../../api/entites.dart';
import '../../../provider/provider_play.dart';
import '../bloc/playlist_bloc.dart';

class PlaylistPage extends StatelessWidget {
  final Playlist playlist;

  const PlaylistPage({Key? key, required this.playlist}) : super(key: key);

  static launch(BuildContext context, Playlist playlist) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlaylistPage(playlist: playlist)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PlaylistBloc(playlist: playlist)..add(new LoadMusicEvent()),
      child: BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state) {
          return Consumer<PlayProvider>(builder: (BuildContext context, playProvider, Widget? child) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            state.coverUrl == null
                                ? Container(
                              width: 120,
                              height: 120,
                              child: Center(
                                  child: Icon(
                                    Icons.playlist_play_rounded,
                                    size: 48,
                                  )),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                              ),
                            )
                                : Container(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(state.coverUrl!)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 120,
                                margin: EdgeInsets.only(left: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                          child: Text(
                                            playlist.displayName,
                                            style: TextStyle(fontSize: 22),
                                          )),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(top: 8),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            for (var music in state.musics) {
                                              playProvider.addMusicToPlayList(music);
                                            }
                                            playProvider.assetsAudioPlayer.next();
                                          }, child: Text("Play")),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                        child: MusicList(
                          list: state.musics,
                        ))
                  ],
                ),
              ),
              bottomNavigationBar: PlayBar(),
            );
          },

          );
        },
      ),
    );
  }
}
