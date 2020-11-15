import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/components/item_album.dart';
import 'package:youmusic_mobile/ui/components/item_artist.dart';
import 'package:youmusic_mobile/ui/components/item_music.dart';
import 'package:youmusic_mobile/ui/components/widget_search.dart';
import 'package:youmusic_mobile/ui/home/tabs/home/provider.dart';

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
                        return AlbumItem(
                          album: e,
                        );
                      }).toList()),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: buildRow(
                        provider,
                        "🎸 Artist",
                        provider.artistLoader.list.map((e) {
                          return ArtistItem(
                            artist: e,
                          );
                        }).toList()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: buildRow(
                        provider,
                        "🎶 Music",
                        provider.musicLoader.list.map((e) {
                          return MusicItem(
                            music: e,
                            onTap: (music) {
                              playProvider.loadMusic(music);
                            },
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
            child: GridView.count(
              childAspectRatio: 13 / 9,
              scrollDirection: Axis.horizontal,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              crossAxisCount: 1,
              children: items,
            ),
          ),
        )
      ],
    );
  }
}
