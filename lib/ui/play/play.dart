import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/play/slider.dart';
import 'package:youmusic_mobile/ui/playlist/playlist.dart';
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
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: provider.assetsAudioPlayer.current,
          builder: (context, asyncSnapshot) {
            Playing? current = asyncSnapshot.data as Playing?;
            var currentPlayId = current?.audio.audio.metas.id;
            var currentCoverUrl = current?.audio.audio.metas.image?.path;
            if (currentPlayId != null && currentPlayId != provider.lyricId) {
              provider.loadLyrics(currentPlayId);
            }
            renderContent() {
              if (displayMode == "Cover") {
                return currentCoverUrl != null
                    ? Container(
                        width: 320,
                        height: 320,
                        child: Image.network(currentCoverUrl),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                      )
                    : Container(
                        width: 320,
                        height: 320,
                        child: Center(
                          child: Icon(
                            Icons.music_note,
                            color: Colors.white,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.pink,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                      );
              }
              if (displayMode == "Lyrics") {
                if (provider.lyricsManager == null) {
                  return Container(
                    width: 320,
                    height: 320,
                    child: Center(),
                  );
                }
                // fine position

                return Container(
                  width: 360,
                  height: 360,
                  child: StreamBuilder(
                      stream: provider.assetsAudioPlayer.currentPosition,
                      builder: (context, asyncSnapshot) {
                        LyricsManager? lyricsManager = provider.lyricsManager;
                        if (lyricsManager == null) {
                          return Center(
                            child: Text(
                              "No lyrics",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        int lyricCur = -1;
                        if (asyncSnapshot.hasData) {
                          final Duration? duration =
                              asyncSnapshot.data as Duration?;
                          if (duration != null) {
                            int curInMil = duration.inMilliseconds;
                            lyricCur = lyricsManager.getIndex(curInMil);
                          }
                        }
                        List<Widget> lines = [];
                        for (int idx = 0;
                            idx < lyricsManager.lines.length;
                            idx++) {
                          LyricsLine lyricsLine = lyricsManager.lines[idx];
                          lines.add(
                            Container(
                              margin: EdgeInsets.only(top: 8, bottom: 8),
                              child: Text(
                                lyricsLine.text,
                                style: TextStyle(
                                    color: lyricCur == idx
                                        ? Colors.pink
                                        : Colors.white,
                                    fontSize: 22),
                              ),
                            ),
                          );
                        }
                        int scrollCur = lyricCur;
                        if (scrollCur - 2 >= 0) {
                          scrollCur -= 2;
                        }
                        _scrollController.scrollTo(
                            index: scrollCur,
                            duration: Duration(milliseconds: 500));

                        return ScrollablePositionedList.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemScrollController: _scrollController,
                          itemCount: lyricsManager.lines.length,
                          itemBuilder: (context, index) {
                            return lines[index];
                          },
                        );
                      }),
                );
              }
              return Container(
                width: 360,
                height: 360,
              );
            }

            return Builder(
              builder: (buildContext) {
                return Padding(
                  padding: EdgeInsets.only(top: 0, left: 36, right: 36),
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
                                        ? Colors.pink
                                        : Colors.white70),
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
                                        ? Colors.pink
                                        : Colors.white70),
                              ))
                        ],
                      ),
                      renderContent(),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 48,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    current?.audio.audio.metas.title ??
                                        "Unknown",
                                    style: TextStyle(
                                      color: Colors.pinkAccent,
                                      fontSize: 28,
                                    ),
                                    softWrap: false,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 32,
                              child: Text(
                                current?.audio.audio.metas.artist ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300),
                                softWrap: false,
                              ),
                            ),
                            Container(
                              height: 32,
                              child: Text(
                                current?.audio.audio.metas.album ?? "",
                                style: TextStyle(
                                    color: Colors.white,
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
                                          .assetsAudioPlayer.currentPosition,
                                      builder: (context, asyncSnapshot) {
                                        final Duration? duration =
                                            asyncSnapshot.data as Duration?;
                                        return Text(
                                          formatDuration(
                                              duration ?? Duration.zero),
                                          style: TextStyle(color: Colors.white),
                                        );
                                      }),
                                  StreamBuilder(
                                      stream:
                                          provider.assetsAudioPlayer.current,
                                      builder: (context, asyncSnapshot) {
                                        final Playing? playing =
                                            asyncSnapshot.data as Playing?;
                                        return Text(
                                          formatDuration(playing?.audio.audio
                                                  .metas.extra?["duration"] ??
                                              Duration.zero),
                                          style: TextStyle(color: Colors.white),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                  stream: provider.assetsAudioPlayer.loopMode,
                                  builder: (context, asyncSnapshot) {
                                    LoopMode? loopMode = asyncSnapshot.data as LoopMode?;
                                    return IconButton(
                                      icon: Icon(getLoopIcon(loopMode),
                                          color: Colors.white),
                                      iconSize: 32,
                                      onPressed: () {
                                        provider.assetsAudioPlayer.toggleLoop();
                                      },
                                    );
                                  }),
                              IconButton(
                                icon: Icon(Icons.skip_previous_rounded,
                                    color: Colors.white),
                                iconSize: 32,
                                onPressed: () {
                                  provider.assetsAudioPlayer.previous();
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: StreamBuilder(
                                  stream: provider.assetsAudioPlayer.isPlaying,
                                  builder: (context, asyncSnapshot) {
                                    final bool isPlaying = asyncSnapshot.data as bool? ?? false;
                                    return Container(
                                      child: IconButton(
                                        icon: Icon(
                                          isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.pink,
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
                                icon:
                                    Icon(Icons.skip_next, color: Colors.white),
                                iconSize: 32,
                                onPressed: () {
                                  provider.assetsAudioPlayer.next();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.library_music_sharp,
                                    color: Colors.white),
                                iconSize: 32,
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: buildContext,
                                      builder: (context) => PlaylistModal());
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
      );
    });
  }
}
