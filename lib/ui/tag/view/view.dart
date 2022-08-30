



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youmusic_mobile/ui/tag/view/tab_album.dart';
import 'package:youmusic_mobile/ui/tag/view/tab_music.dart';

import '../../components/album-filter.dart';
import '../../components/music-filter.dart';
import '../../home/play_bar.dart';
import '../bloc/tag_bloc.dart';

class TagView extends StatelessWidget {
  final String id;

  const TagView({Key? key, required this.id}) : super(key: key);

  static launch(BuildContext context, String? tagId) {
    var id = tagId;
    if (id == null) {
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TagView(
                  id: id,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return BlocProvider(
      create: (context) => TagBloc(id: id)..add(InitEvent()),
      child: BlocBuilder<TagBloc, TagState>(
        builder: (context, state) {
          _onAlbumFilterButtonClick() {
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return AlbumFilterView(
                    filter: state.albumFilter,
                    onChange: (filter) {
                      BlocProvider.of<TagBloc>(context)
                          .add(AlbumFilterUpdatedEvent(filter));
                      // if (controller.hasClients && controller.offset > 0){
                      //   controller.jumpTo(0);
                      // }
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
                      BlocProvider.of<TagBloc>(context)
                          .add(MusicFilterUpdatedEvent(filter));
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
                state.displayTagName,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(onPressed: (){
                  if (state.isFollow) {
                    BlocProvider.of<TagBloc>(context)
                        .add(UnFollowEvent());
                  } else {
                    BlocProvider.of<TagBloc>(context)
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
                                  BlocProvider.of<TagBloc>(context)
                                      .add(TabChangeEvent(0));
                                  controller.animateToPage(0,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeInOut);
                                },
                                backgroundColor: state.idx == 0
                                    ? Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                    : Colors.transparent),
                          ),
                          ActionChip(
                              label: Text("Music"),
                              onPressed: () {
                                BlocProvider.of<TagBloc>(context)
                                    .add(TabChangeEvent(1));
                                controller.animateToPage(1,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeInOut);
                              },
                              backgroundColor: state.idx == 1
                                  ? Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  : Colors.transparent),
                          Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(Icons.filter_alt_rounded),
                                  onPressed: () {
                                    if (state.idx == 0) {
                                      _onAlbumFilterButtonClick();
                                    }
                                    if (state.idx == 1) {
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
                          BlocProvider.of<TagBloc>(context)
                              .add(TabChangeEvent(idx));
                        },
                        controller: controller,
                        children: <Widget>[
                          Container(
                            child: TagTabAlbum(),
                          ),
                          Center(
                            child: TagTabMusic(),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            bottomNavigationBar: Container(
                color: Theme.of(context)
                    .colorScheme
                    .background
                    .withOpacity(0.3),
                child: PlayBar()),
          );
        },
      ),
    );
  }
}
