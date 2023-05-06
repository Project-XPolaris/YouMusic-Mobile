import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/ui/meta-navigation/music.dart';
import 'package:youmusic_mobile/utils/color.dart';
import 'package:youmusic_mobile/utils/time.dart';

import '../../tag/view/view.dart';
import '../bloc/album_bloc.dart';

class AlbumPage extends StatefulWidget {
  final int id;
  final String? initCover;
  final String? blurHash;

  const AlbumPage({Key? key, required this.id, this.blurHash, this.initCover})
      : super(key: key);

  static launch(BuildContext context, int? albumId,
      {String? cover, ImageProvider? imageProvider, String? blurHash}) {
    var id = albumId;
    if (id == null) {
      return;
    }
    BlurHashImage image = BlurHashImage(
      blurHash ?? "",
    );

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AlbumPage(
                id: id,
                initCover: cover,
                blurHash: blurHash,
              )),
    );
  }

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  bool appbarBlur = false;
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AlbumBloc(id: this.widget.id)..add(AlbumInitialEvent()),
      child: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            return Theme(
                data: ThemeData(
                    colorSchemeSeed: state.album?.color != null
                        ? hexToColor(state.album!.color!)
                        : Theme.of(context).colorScheme.primary,
                    brightness: Theme.of(context).brightness),
                child: Builder(builder: (BuildContext context) {
                  var albumCoverUrl =
                      state.album?.getCoverUrl() ?? widget.initCover;
                  List<Widget> renderMusicList() {
                    var musics = state.album?.music ?? [];
                    return List.generate(musics.length, (index) => index)
                        .map((idx) {
                      var music = musics[idx];
                      var displayIdx = (idx + 1).toString();
                      return ListTile(
                        minVerticalPadding: 16,
                        minLeadingWidth: 12,
                        title: Text(
                          music.title ?? "No title",
                          style: TextStyle(),
                        ),
                        subtitle: Text(music.getArtistString("Unknown"),
                            style: TextStyle(fontSize: 12)),
                        onTap: () {
                          music.album = state.album;
                          playProvider.playMusic(music, autoPlay: true);
                        },
                        onLongPress: () {
                          music.album = state.album;
                          HapticFeedback.selectionClick();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => MusicMetaInfo(
                                    music: music,
                                  ));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        trailing: Text(
                          formatDuration(Duration(seconds: music.duration?.toInt() ?? 0)),
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList();
                  }

                  return Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: BlurHashImage(
                          widget.blurHash ?? "",
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.1), BlendMode.darken),
                      ),
                    ),
                    child: Scaffold(
                      backgroundColor: widget.blurHash != null
                          ? (Theme.of(context).brightness == Brightness.dark
                              ? Colors.black54
                              : Colors.white70)
                          : null,
                      extendBodyBehindAppBar: true,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        //   width: MediaQuery.of(context).size.width,
                        //  height: MediaQuery.of(context).padding.top,
                        actions: [
                          IconButton(
                              onPressed: () {
                                var album = state.album;
                                if (album == null) {
                                  return;
                                }
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => AlbumMetaInfo(
                                          album: album,
                                        ));
                              },
                              icon: Icon(Icons.info_outline_rounded)),
                          IconButton(
                              onPressed: () {
                                if (state.album == null) {
                                  return;
                                }
                                if (state.isFollow) {
                                  context
                                      .read<AlbumBloc>()
                                      .add(UnFollowEvent());
                                } else {
                                  context.read<AlbumBloc>().add(FollowEvent());
                                }
                              },
                              icon: Icon(state.isFollow
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded))
                        ],
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      body: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: NotificationListener(
                          child: ListView(
                            controller: _scrollController,
                            children: [
                              Container(
                                width: 360,
                                height: 360,
                                padding: const EdgeInsets.only(
                                    left: 32, right: 32, top: 16),
                                child: Container(
                                  child: (albumCoverUrl ?? widget.initCover) !=
                                          null
                                      ? Container(
                                          child: Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Container(
                                                child: Image.network(
                                                  albumCoverUrl ?? "",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Container(
                                                width: 280,
                                                height: 280,
                                                child: Icon(
                                                  Icons.album_rounded,
                                                  size: 64,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0)))),
                                          ),
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: Text(
                                  state.album?.name ?? "unknown",
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 22),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Text(
                                  state.album?.getArtist("Unknown") ??
                                      "Unknown",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 32),
                                child: Center(
                                  child: Wrap(
                                    children: [
                                      ...state.tags.map((tag) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8, bottom: 0),
                                          child: ActionChip(
                                            onPressed: () {
                                              TagView.launch(
                                                  context, tag.id?.toString());
                                            },
                                            label: Text(tag.displayName),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer,
                                            labelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondaryContainer),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    bottom: 16, left: 16, right: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "All music",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.play_arrow_rounded,
                                      ),
                                      onPressed: () {
                                        var albumId = state.album?.id;
                                        if (albumId != null) {
                                          playProvider.playAlbum(albumId);
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                              ...renderMusicList()
                            ],
                          ),
                          onNotification: (notification) {
                            if (notification is ScrollMetricsNotification) {
                              var pixel = _scrollController.position.pixels;
                              if (pixel > 10 && !appbarBlur) {
                                setState(() {
                                  appbarBlur = true;
                                });
                              }
                              if (pixel <= 10 && appbarBlur) {
                                setState(() {
                                  appbarBlur = false;
                                });
                              }
                            }
                            return true;
                          },
                        ),
                      ),
                      bottomNavigationBar: Container(
                          color: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.3),
                          child: PlayBar()),
                    ),
                  );
                }));
          });
        },
      ),
    );
  }
}
