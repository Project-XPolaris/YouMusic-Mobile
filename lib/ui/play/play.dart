import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/components/maq.dart';
import 'package:youmusic_mobile/ui/play/slider.dart';
import 'package:youmusic_mobile/ui/queue/playlist.dart';
import 'package:youmusic_mobile/utils/icons.dart';
import 'package:youmusic_mobile/utils/lyric.dart';
import 'package:youmusic_mobile/utils/time.dart';

class PlayPage extends StatefulWidget {
  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  String displayMode = "Cover";
  ItemScrollController _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, provider, child) {
      return StreamBuilder(
          stream: provider.assetsAudioPlayer.current,
          builder: (context, asyncSnapshot) {
            Playing? current = asyncSnapshot.data as Playing?;
            var currentCoverUrl = current?.audio.audio.metas.image?.path;
            var currentBlurHash = current?.audio.audio.metas.extra!["blurHash"];
            return Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: BlurHashImage(currentBlurHash ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black.withOpacity(0.5),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  elevation: 0,
                ),
                body: StreamBuilder(
                  stream: provider.assetsAudioPlayer.current,
                  builder: (context, asyncSnapshot) {
                    Playing? current = asyncSnapshot.data as Playing?;
                    var currentPlayId = current?.audio.audio.metas.id;
                    var currentCoverUrl =
                        current?.audio.audio.metas.image?.path;
                    if (currentPlayId != null &&
                        currentPlayId != provider.lyricId) {
                      provider.loadLyrics(currentPlayId);
                    }
                    renderContent() {
                      if (displayMode == "Cover") {
                        return Container(
                          width: 320,
                          height: 320,
                          color: Colors.transparent,
                          child: Center(
                            child: Card(
                              elevation: 10,
                              child: currentCoverUrl != null
                                  ? Container(
                                      child: Image.network(currentCoverUrl),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16.0))),
                                    )
                                  : Container(
                                      width: 320,
                                      height: 320,
                                      child: Center(
                                        child: Icon(
                                          Icons.music_note_rounded,
                                        ),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16.0))),
                                    ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                            ),
                          ),
                        );
                      }
                      if (displayMode == "Lyrics") {
                        LyricsManager? lyricsManager = provider.lyricsManager;
                        if (lyricsManager == null) {
                          return Container(
                            width: 320,
                            height: 320,
                            child: Center(
                              child: Text(
                                "No lyrics",
                              ),
                            ),
                          );
                        }
                        List<Widget> lines = [];
                        for (int idx = 0;
                            idx < lyricsManager.lines.length;
                            idx++) {
                          LyricsLine lyricsLine = lyricsManager.lines[idx];
                          lines.add(
                            Container(
                              margin: EdgeInsets.only(top: 8, bottom: 8),
                              child: StreamBuilder(
                                  stream: provider
                                      .assetsAudioPlayer.currentPosition,
                                  builder: (context, asyncSnapshot) {
                                    int lyricCur = -1;
                                    if (asyncSnapshot.hasData) {
                                      final Duration? duration =
                                          asyncSnapshot.data as Duration?;
                                      if (duration != null) {
                                        int curInMil =
                                            duration.inMilliseconds;
                                        lyricCur =
                                            lyricsManager.getIndex(curInMil);
                                      }
                                    }
                                    lyricsManager.getIndex(lyricCur);
                                    return Text(
                                      lyricsLine.text,
                                      style: TextStyle(
                                          color: lyricCur == idx
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.white,
                                          fontSize: 22),
                                    );
                                  }),
                            ),
                          );
                        }
                        provider.assetsAudioPlayer.currentPosition
                            .listen((duration) {
                          int lyricCur = -1;
                          int curInMil = duration.inMilliseconds;
                          lyricCur = lyricsManager.getIndex(curInMil);
                          lyricsManager.getIndex(lyricCur);
                          int scrollCur = lyricCur;
                          if (scrollCur - 2 >= 0) {
                            scrollCur -= 2;
                          }
                          _scrollController.scrollTo(
                              index: lyricCur,
                              duration: Duration(milliseconds: 500));
                        });
                        // fine position
                        return Container(
                            width: 360,
                            height: 360,
                            child: ScrollablePositionedList.builder(
                              itemScrollController: _scrollController,
                              itemCount: lines.length,
                              itemBuilder: (context, index) {
                                return lines[index];
                              },
                            ));
                      }
                      return Container(
                        width: 360,
                        height: 360,
                      );
                    }

                    return Builder(
                      builder: (buildContext) {
                        return Padding(
                          padding:
                              EdgeInsets.only(top: 0, left: 36, right: 36),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          displayMode = "Cover";
                                        });
                                      },
                                      child: Text(
                                        "Cover",
                                        style: TextStyle(
                                            color: displayMode == "Cover"
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onBackground),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          displayMode = "Lyrics";
                                        });
                                      },
                                      child: Text(
                                        "Lyrics",
                                        style: TextStyle(
                                            color: displayMode == "Lyrics"
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onBackground),
                                      ))
                                ],
                              ),
                              renderContent(),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    MarqueeWidget(child:
                                    Text( current?.audio.audio.metas.title ?? "Unknown",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 28,
                                      ),
                                      softWrap: false,
                                    )),
                                    Container(
                                      height: 32,
                                      child: Text(
                                        current?.audio.audio.metas.artist ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                        softWrap: false,
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      child: Text(
                                        current?.audio.audio.metas.album ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300),
                                        softWrap: false,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 32),
                                child: Column(
                                  children: [
                                    PlaySlider(),
                                    Container(
                                      margin: EdgeInsets.only(top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          StreamBuilder(
                                              stream: provider
                                                  .assetsAudioPlayer
                                                  .currentPosition,
                                              builder:
                                                  (context, asyncSnapshot) {
                                                final Duration? duration =
                                                    asyncSnapshot.data
                                                        as Duration?;
                                                return Text(
                                                  formatDuration(duration ??
                                                      Duration.zero),
                                                );
                                              }),
                                          StreamBuilder(
                                              stream: provider
                                                  .assetsAudioPlayer.current,
                                              builder:
                                                  (context, asyncSnapshot) {
                                                final Playing? playing =
                                                    asyncSnapshot.data
                                                        as Playing?;
                                                return Text(
                                                  formatDuration(playing
                                                              ?.audio
                                                              .audio
                                                              .metas
                                                              .extra?[
                                                          "duration"] ??
                                                      Duration.zero),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      StreamBuilder(
                                          stream: provider
                                              .assetsAudioPlayer.loopMode,
                                          builder: (context, asyncSnapshot) {
                                            LoopMode? loopMode = asyncSnapshot
                                                .data as LoopMode?;
                                            return IconButton(
                                              icon: Icon(
                                                getLoopIcon(loopMode),
                                              ),
                                              iconSize: 32,
                                              onPressed: () {
                                                provider.assetsAudioPlayer
                                                    .toggleLoop();
                                              },
                                            );
                                          }),
                                      IconButton(
                                        icon:
                                            Icon(Icons.skip_previous_rounded),
                                        iconSize: 32,
                                        onPressed: () {
                                          provider.assetsAudioPlayer
                                              .previous();
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: StreamBuilder(
                                          stream: provider
                                              .assetsAudioPlayer.isPlaying,
                                          builder: (context, asyncSnapshot) {
                                            final bool isPlaying =
                                                asyncSnapshot.data as bool? ??
                                                    false;
                                            return Container(
                                              child: IconButton(
                                                icon: Icon(
                                                  isPlaying
                                                      ? Icons.pause_rounded
                                                      : Icons.play_arrow_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                onPressed: () async {
                                                  provider.assetsAudioPlayer
                                                      .playOrPause();
                                                },
                                                iconSize: 48,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.skip_next_rounded),
                                        iconSize: 32,
                                        onPressed: () {
                                          provider.assetsAudioPlayer.next();
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.library_music_rounded,
                                        ),
                                        iconSize: 32,
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: buildContext,
                                              builder: (context) =>
                                                  PlaylistModal());
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          });
    });
  }
}
