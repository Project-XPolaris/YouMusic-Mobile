import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/components/item_album.dart';
import 'package:youmusic_mobile/ui/components/item_artist.dart';
import 'package:youmusic_mobile/ui/components/item_music.dart';
import 'package:youmusic_mobile/ui/components/widget_search.dart';
import 'package:youmusic_mobile/ui/home/tabs/home/provider.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/ui/meta-navigation/artist.dart';
import 'package:youmusic_mobile/ui/meta-navigation/music.dart';
import 'package:youmusic_mobile/ui/meta-navigation/view.dart';

class HomeTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeTabProvider>(
        create: (_) => HomeTabProvider(),
        child: Consumer<PlayProvider>(builder: (context, playProvider, child) {
          return Consumer<HomeTabProvider>(builder: (context, provider, child) {
            provider.loadData();
            return Container(
                child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Text(
                      "Hey there 👋",
                      style: TextStyle(color: Colors.pink, fontSize: 32),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    child: SearchBox(),
                  ),
                  buildRow(
                      provider,
                      "💿 Album",
                      provider.albumLoader.list.map((e) {
                        return Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: AlbumItem(
                            album: e,
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
                        provider,
                        "🎸 Artist",
                        provider.artistLoader.list.map((e) {
                          return Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: ArtistItem(
                                artist: e,
                                onLongPress: (artist) {
                                  HapticFeedback.selectionClick();
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => ArtistMetaInfo(
                                            artist: artist,
                                          ));
                                }),
                          );
                        }).toList()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: buildRow(
                        provider,
                        "🎶 Music",
                        provider.musicLoader.list.map((e) {
                          return Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: MusicItem(
                                music: e,
                                onTap: (music) {
                                  playProvider.loadMusic(music);
                                },
                                onLongPress: (music) {
                                  HapticFeedback.selectionClick();
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => MusicMetaInfo(
                                            music: music,
                                          ));
                                }),
                          );
                        }).toList()),
                  ),
                ],
              ),
            ));
          });
        }));
  }

  Column buildRow(HomeTabProvider provider, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 20),
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
