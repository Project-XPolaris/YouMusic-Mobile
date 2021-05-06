import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album-list/album_list.dart';
import 'package:youmusic_mobile/ui/album/album.dart';
import 'package:youmusic_mobile/ui/artist/artist.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/ui/meta-navigation/artist.dart';
import 'package:youmusic_mobile/ui/meta-navigation/music.dart';
import 'package:youmusic_mobile/ui/music-list/music_list.dart';
import 'package:youmusic_mobile/ui/search/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchKey;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchProvider>(
        create: (_) => SearchProvider(),
        child: Consumer<SearchProvider>(builder: (context, provider, child) {
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            List<Widget> renderResultRow({Widget header, content, bool empty}) {
              if (empty) {
                return [];
              }
              return [
                header,
                ...content,
              ];
            }

            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Container(
                  height: 48,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: TextField(
                            cursorColor: Colors.pink,
                            decoration: InputDecoration(
                              hintText: "Search...",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.white60),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            onChanged: (text) {
                              setState(() {
                                searchKey = text;
                              });
                            },
                          ),
                        ),
                        flex: 1,
                      ),
                      Container(
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            Icons.search,
                            color: Colors.pink,
                          ),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            provider.search(searchKey);
                          },
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white30,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(32))),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    ...renderResultRow(
                      empty: provider.musicLoader.list.isEmpty,
                      header: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Music",
                                style: TextStyle(color: Colors.white70),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MusicListPage(
                                                extraFilter: {
                                                  "search": searchKey
                                                },
                                                title: "Result in $searchKey",
                                              )),
                                    );
                                  },
                                  child: Text(
                                    "More",
                                    style: TextStyle(color: Colors.pink),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      content: provider.musicLoader.list.map((music) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              music.title,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              music.album?.name ?? "unknown",
                              style: TextStyle(color: Colors.white70),
                            ),
                            leading: Image.network(
                              music.album?.getCoverUrl(),
                              width: 64,
                            ),
                            onLongPress: () {
                              HapticFeedback.selectionClick();
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => MusicMetaInfo(
                                        music: music,
                                      ));
                            },
                            onTap: () {
                              playProvider.playMusic(music, autoPlay: true);
                            },
                          ),
                        );
                      }),
                    ),
                    ...renderResultRow(
                        empty: provider.albumLoader.list.isEmpty,
                        header: Padding(
                          padding: const EdgeInsets.only(bottom: 16, top: 16),
                          child: Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Album",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AlbumListPage(
                                                  extraFilter: {
                                                    "search": searchKey
                                                  },
                                                  title: "Result in $searchKey",
                                                )),
                                      );
                                    },
                                    child: Text(
                                      "More",
                                      style: TextStyle(color: Colors.pink),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        content: provider.albumLoader.list.map((album) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                album.name,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                album?.getArtist("unknown"),
                                style: TextStyle(color: Colors.white70),
                              ),
                              leading: Image.network(
                                album.getCoverUrl(),
                                width: 64,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlbumPage(
                                            id: album.id,
                                          )),
                                );
                              },
                              onLongPress: () {
                                HapticFeedback.selectionClick();
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => AlbumMetaInfo(
                                          album: album,
                                        ));
                              },
                            ),
                          );
                        })),
                    ...renderResultRow(
                        empty: provider.artistLoader.list.isEmpty,
                        header: Padding(
                          padding: const EdgeInsets.only(bottom: 16, top: 16),
                          child: Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Artist",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                        content: provider.artistLoader.list.map((artist) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(
                                artist.name,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: Image.network(
                                artist.getAvatarUrl(),
                                width: 64,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArtistPage(
                                            id: artist.id,
                                          )),
                                );
                              },
                              onLongPress: () {
                                HapticFeedback.selectionClick();
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => ArtistMetaInfo(
                                          artist: artist,
                                        ));
                              },
                            ),
                          );
                        })),
                  ],
                ),
              ),
              bottomNavigationBar: PlayBar(),
            );
          });
        }));
  }
}
