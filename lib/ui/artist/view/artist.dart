import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album-list/album_list.dart';
import 'package:youmusic_mobile/ui/artist/bloc/artist_bloc.dart';
import 'package:youmusic_mobile/ui/components/item_album.dart';
import 'package:youmusic_mobile/ui/components/music-list-item.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/ui/meta-navigation/music.dart';
import 'package:youmusic_mobile/ui/music-list/music_list.dart';

class ArtistPage extends StatefulWidget {
  final int id;

  const ArtistPage({Key? key, required this.id}) : super(key: key);

  static launch(BuildContext context, int? artistId) {
    var id = artistId;
    if (id == null) {
      return;
    }
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ArtistPage(
                id: id,
              )),
    );
  }

  @override
  _ArtistPageState createState() => _ArtistPageState(id);
}

class _ArtistPageState extends State<ArtistPage> {
  var headAlpha = 0;
  final int id;

  _ArtistPageState(this.id);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArtistBloc(artistId: id)..add(InitEvent()),
      child: BlocBuilder<ArtistBloc, ArtistState>(
        builder: (context, state) {
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            List<String> getMoreMenu() {
              var menu = <String>[];
              if (state.artist != null) {
                menu.add("All Album");
                menu.add("All Music");
                if (state.isFollow) {
                  menu.add("Unfollow");
                } else {
                  menu.add("Follow");
                }
              }
              return menu;
            }

            String? getPersonAvatar() {
              var url = state.artist?.getAvatarUrl();
              if (url != null) {
                return url;
              }
              Album? album = state.albumList
                  .firstWhereOrNull((album) => album.getCoverUrl() != null);
              if (album != null) {
                return album.getCoverUrl();
              }
              return null;
            }

            var coverUrl = getPersonAvatar();
            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 320.0,
                      floating: false,
                      pinned: true,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          centerTitle: true,
                          stretchModes: [StretchMode.zoomBackground],
                          title: Container(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Text(state.artist?.name ?? "Unknown",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 16.0,
                                )),
                          ),
                          background: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: coverUrl != null
                                      ? Image.network(
                                          coverUrl,
                                          fit: BoxFit.cover,
                                          scale: 2,
                                        )
                                      : Container(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          child: Center(
                                            child: Icon(
                                              Icons.person,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              size: 120,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Theme.of(context).colorScheme.background
                                    ], // red to yellow
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text("${state.albumList.length} Album, ${state.musicList.length} Music",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground.withAlpha(150),
                                          fontSize: 14.0,
                                        )),
                                  ))
                            ],
                          )),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_rounded),
                        onPressed: () {
                          Navigator.pop(
                              context, {'isFollow': state.isFollow, 'id': id});
                        },
                      ),
                      actions: [
                        PopupMenuButton<String>(
                          onSelected: (option) {
                            switch (option) {
                              case "All Album":
                                AlbumListPage.launch(context,
                                    extraFilter: {
                                      "artist": widget.id.toString()
                                    },
                                    title: "Album by ${state.artist?.name}");
                                break;
                              case "All Music":
                                MusicListPage.launch(context,
                                    extraFilter: {
                                      "artist": widget.id.toString()
                                    },
                                    title: "Music by ${state.artist?.name}");
                                break;
                              case "Follow":
                                BlocProvider.of<ArtistBloc>(context)
                                    .add(FollowEvent());
                                break;
                              case "Unfollow":
                                BlocProvider.of<ArtistBloc>(context)
                                    .add(UnFollowEvent());
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return getMoreMenu().map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                  ];
                },
                body: Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 32, left: 16, right: 16),
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Music",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                GestureDetector(
                                  child: Text(
                                    "More",
                                  ),
                                  onTap: () {
                                    MusicListPage.launch(context,
                                        extraFilter: {
                                          "artist": widget.id.toString()
                                        },
                                        title:
                                            "Music by ${state.artist?.name}");
                                  },
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Column(
                                children: (state.musicList).map((music) {
                                  return MusicListTileItem(
                                      music: music,
                                      onTap: (music) {
                                        playProvider.playMusic(music,
                                            autoPlay: true);
                                      },
                                      onLongPress: (music) {
                                        HapticFeedback.selectionClick();
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) => MusicMetaInfo(
                                                  music: music,
                                                ));
                                      });
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Album",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      "More",
                                      style: TextStyle(),
                                    ),
                                    onTap: () {
                                      AlbumListPage.launch(context,
                                          extraFilter: {
                                            "artist": widget.id.toString()
                                          },
                                          title:
                                              "Album by ${state.artist?.name}");
                                    },
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 16),
                                child: Container(
                                  height: 160,
                                  child: state.albumList.length > 0
                                      ? GridView.count(
                                          childAspectRatio: 13 / 9,
                                          scrollDirection: Axis.horizontal,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8,
                                          crossAxisCount: 1,
                                          children:
                                              state.albumList.map((album) {
                                            return AlbumItem(
                                              onTap: (contextAlbum) {
                                                var id = contextAlbum.id;
                                                if (id == null) {
                                                  return;
                                                }
                                                playProvider.playAlbum(id);
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
                                              album: album,
                                            );
                                          }).toList(),
                                        )
                                      : Container(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: PlayBar(),
            );
          });
        },
      ),
    );
  }
}
