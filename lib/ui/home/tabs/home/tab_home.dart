
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album/view/album.dart';
import 'package:youmusic_mobile/ui/artist/view/artist.dart';
import 'package:youmusic_mobile/ui/components/item_album.dart';
import 'package:youmusic_mobile/ui/components/item_artist.dart';
import 'package:youmusic_mobile/ui/components/item_music.dart';
import 'package:youmusic_mobile/ui/components/widget_search.dart';
import 'package:youmusic_mobile/ui/home/tabs/home/provider.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/ui/meta-navigation/artist.dart';
import 'package:youmusic_mobile/ui/meta-navigation/music.dart';
import 'package:youmusic_mobile/ui/search/index.dart';

class HomeTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeTabProvider>(
        create: (_) => HomeTabProvider(),
        child: Consumer<PlayProvider>(builder: (context, playProvider, child) {
          return Consumer<HomeTabProvider>(builder: (context, provider, child) {
            provider.loadData();
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "YouMusic",
                ),
                elevation: 0,
              ),
              body: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await provider.loadData(force: true);
                      },
                      child: ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Text(
                              "Hey there 👋",
                              style:
                                  TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 32),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 24),
                            child: GestureDetector(
                              child: SearchBox(),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchPage()),
                                );
                              },
                            ),
                          ),
                          buildRow(
                              "💿 Album",
                              provider.albumLoader.list.map((e) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: AlbumItem(
                                    album: e,
                                    onTap: (album) {
                                      AlbumPage.launch(context, e.id,cover: e.getCoverUrl(),blurHash: e.blurHash);
                                    },
                                    onLongPress: (album) {
                                      HapticFeedback.selectionClick();
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) => AlbumMetaInfo(
                                                album: album,
                                              ));
                                    },
                                  ),
                                );
                              }).toList()),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: buildRow(
                                "🎸 Artist",
                                provider.artistLoader.list.map((e) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: ArtistItem(
                                        artist: e,
                                        onTap: (music) {
                                          int? artistId = e.id;
                                          if (artistId == null) {
                                            return;
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ArtistPage(
                                                      id: artistId,
                                                    )),
                                          );
                                        },
                                        onLongPress: (artist) {
                                          HapticFeedback.selectionClick();
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  ArtistMetaInfo(
                                                    artist: artist,
                                                  ));
                                        }),
                                  );
                                }).toList()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: buildRow(
                                "🎶 Music",
                                provider.musicLoader.list.map((e) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: MusicItem(
                                        music: e,
                                        onTap: (music) {
                                          playProvider.playMusic(music,
                                              autoPlay: true);
                                        },
                                        onLongPress: (music) {
                                          HapticFeedback.selectionClick();
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  MusicMetaInfo(
                                                    music: music,
                                                  ));
                                        }),
                                  );
                                }).toList()),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          });
        }));
  }

  Column buildRow(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.end,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            height: 160,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items,
            ),
          ),
        )
      ],
    );
  }
}
