import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/ui/genre/bloc/genre_bloc.dart';
import 'package:youmusic_mobile/ui/genre/view/tab_music.dart';

import '../../components/album-filter.dart';
import '../../components/music-filter.dart';
import '../../home/play_bar.dart';
import 'tab_album.dart';

class GenreView extends StatelessWidget {
  final String id;
  final String title;

  const GenreView({Key? key, required this.id, this.title = "Genre"})
      : super(key: key);

  static launch(BuildContext context, String? genreId, {String? title}) {
    var id = genreId;
    if (id == null) {
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GenreView(
                  id: id,
                  title: title ?? "Genre",
                )));
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return BlocProvider(
      create: (context) => GenreBloc(genreId: id)
        ..add(InitEvent())
        ..add(LoadMusicEvent(force: false))
        ..add(LoadAlbumEvent(force: false)),
      child: BlocBuilder<GenreBloc, GenreState>(
        builder: (context, state) {
          _onAlbumFilterButtonClick() {
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return AlbumFilterView(
                    filter: state.albumFilter,
                    onChange: (filter) {
                      context
                          .read<GenreBloc>()
                          .add(UpdateAlbumFilterEvent(updatedFilter: filter));
                    },
                  );
                });
          }

          _onMusicFilterButtonClick() {
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return MusicFilterView(
                    filter: state.musicFilter,
                    onChange: (filter) {
                      context
                          .read<GenreBloc>()
                          .add(UpdateMusicFilterEvent(updatedFilter: filter));
                      // if (controller.offset > 0){
                      //   controller.jumpTo(0);
                      // }
                    },
                  );
                });
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.pop(context)),
              title: Text(
                title,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(onPressed: (){
                  if (state.isFollow) {
                    BlocProvider.of<GenreBloc>(context)
                        .add(UnFollowEvent());
                  } else {
                    BlocProvider.of<GenreBloc>(context)
                        .add(FollowEvent());
                  }
                }, icon: Icon(state.isFollow ? Icons.favorite_rounded : Icons.favorite_border_rounded)),
              ],
            ),

            body: Container(
                child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                            label: Text("Albums"),
                            onPressed: () {
                              context
                                  .read<GenreBloc>()
                                  .add(TabIndexChangeEvent(index: 0));
                              controller.animateToPage(0,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut);
                            },
                            backgroundColor: state.index == 0
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Colors.transparent),
                      ),
                      ActionChip(
                          label: Text("Music"),
                          onPressed: () {
                            context
                                .read<GenreBloc>()
                                .add(TabIndexChangeEvent(index: 1));
                            controller.animateToPage(1,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                          backgroundColor: state.index == 1
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Colors.transparent),
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.filter_alt_rounded),
                          onPressed: () {
                            if (state.index == 0) {
                              _onAlbumFilterButtonClick();
                            }
                            if (state.index == 1) {
                              _onMusicFilterButtonClick();
                            }
                          },
                        ),
                      ))
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    onPageChanged: (idx) {
                      context
                          .read<GenreBloc>()
                          .add(TabIndexChangeEvent(index: idx));
                    },
                    controller: controller,
                    children: <Widget>[
                      Container(
                        child: GenreTabAlbum(),
                      ),
                      Center(
                        child: GenreTabMusic(),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            bottomNavigationBar: Container(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.3),
                child: PlayBar()),
          );
        },
      ),
    );
  }
}
