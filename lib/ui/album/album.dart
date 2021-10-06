import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album/provider.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/ui/meta-navigation/music.dart';

class AlbumPage extends StatefulWidget {
  final int id;

  const AlbumPage({Key? key, required this.id}) : super(key: key);

  static launch(BuildContext context, int? albumId) {
    var id = albumId;
    if (id == null) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AlbumPage(
                id: id,
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
    return ChangeNotifierProvider<AlbumProvider>(
        create: (_) => AlbumProvider(widget.id),
        child: Consumer<AlbumProvider>(builder: (context, provider, child) {
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            var albumCoverUrl = provider.album?.getCoverUrl();
            List<Widget> renderMusicList() {
              var musics = provider.album?.music ?? [];
              return List.generate(musics.length, (index) => index).map((idx) {
                var music = musics[idx];
                var displayIdx = (idx + 1).toString();
                return ListTile(
                    minVerticalPadding: 16,
                    minLeadingWidth: 12,
                    leading: Container(
                      width: 24,
                      child: Text(
                        displayIdx,
                        style: TextStyle(color: Colors.white60),
                      ),
                    ),
                    title: Text(
                      music.title ?? "No title",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(music.getArtistString("Unknown"),
                        style: TextStyle(color: Colors.white54, fontSize: 12)),
                    onTap: () {
                      music.album = provider.album;
                      playProvider.playMusic(music, autoPlay: true);
                    },
                    onLongPress: () {
                      music.album = provider.album;
                      HapticFeedback.selectionClick();
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => MusicMetaInfo(
                            music: music,
                          ));
                    });
              }).toList();
            }

            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.black,
              appBar: PreferredSize(
                child: Container(
                  child: ClipRRect(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: appbarBlur ? 35 : 0,
                              sigmaY: appbarBlur ? 35 : 0,
                              tileMode: TileMode.clamp),
                          child: AppBar(
                            //   width: MediaQuery.of(context).size.width,
                            //  height: MediaQuery.of(context).padding.top,
                            actions: [
                              IconButton(onPressed: (){
                                var album = provider.album;
                                if (album == null) {
                                  return;
                                }
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => AlbumMetaInfo(
                                      album: album,
                                    ));
                              }, icon: Icon(Icons.more_vert))
                            ],
                            elevation: 0,
                            backgroundColor: Colors.black12,
                          ))),
                ),
                preferredSize: Size(MediaQuery.of(context).size.width, 56),
              ),
              body: FutureBuilder(
                future: provider.loadData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: NotificationListener(
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 64, right: 64, top: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: albumCoverUrl != null
                                    ? Container(
                                        width: 120,
                                        height: 120,
                                        child: Image.network(
                                          albumCoverUrl,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ))
                                    : Container(
                                        width: 120,
                                        height: 120,
                                      ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32),
                            child: Text(
                              provider.album?.name ?? "unknown",
                              style:
                                  TextStyle(color: Colors.pink, fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 32),
                            child: Text(
                              provider.album?.getArtist("Unknown") ?? "Unknown",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 16, left: 16, right: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "All music",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    var albumId = provider.album?.id;
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
                  );
                },
              ),
              bottomNavigationBar: PlayBar(),
            );
          });
        }));
  }
}
