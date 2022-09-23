import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album-list/album_list.dart';
import 'package:youmusic_mobile/ui/album/view/album.dart';
import 'package:youmusic_mobile/ui/artist-list/artist_list.dart';
import 'package:youmusic_mobile/ui/artist/view/artist.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/ui/meta-navigation/artist.dart';
import 'package:youmusic_mobile/ui/meta-navigation/music.dart';
import 'package:youmusic_mobile/ui/music-list/music_list.dart';
import 'package:youmusic_mobile/ui/playlist-list/view/view.dart';
import 'package:youmusic_mobile/ui/search/provider.dart';

import '../tag-list/view/tag-list.dart';
import '../tag/view/view.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchKey = "";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchProvider>(
        create: (_) => SearchProvider(),
        child: Consumer<SearchProvider>(builder: (context, provider, child) {
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
                List<Widget> renderResultRow({header, content, empty}) {
                  if (empty) {
                    return [];
                  }
                  return [
                    header,
                    ...content,
                  ];
                }

                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    title: Container(
                      height: 38,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: TextField(
                                cursorColor: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(),
                                ),
                                style: TextStyle(
                                  fontSize: 18,
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
                                Icons.search_rounded,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                              ),
                              onPressed: () {
                                FocusScope.of(context).requestFocus(
                                    FocusNode());
                                provider.search(searchKey);
                              },
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .secondaryContainer,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(32))),
                    ),
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    "Music",
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MusicListPage(
                                                    extraFilter: {
                                                      "search": searchKey
                                                    },
                                                    title: "Result in $searchKey",
                                                  )),
                                        );
                                      },
                                      child: Text(
                                        "More",
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
                                  music.title ?? "Unknown",
                                ),
                                subtitle: Text(
                                  music.album?.name ?? "unknown",
                                ),
                                leading: CachedNetworkImage(
                                  imageUrl: music.album?.getCoverUrl() ?? "",
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                      Container(),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .primary,
                                        child: Center(
                                          child: Icon(
                                            Icons.music_note_rounded,
                                          ),
                                        ),
                                      ),
                                  width: 64,
                                ),
                                onLongPress: () {
                                  HapticFeedback.selectionClick();
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          MusicMetaInfo(
                                            music: music,
                                          ));
                                },
                                onTap: () {
                                  playProvider.playMusic(music, autoPlay: true);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            );
                          }),
                        ),
                        ...renderResultRow(
                            empty: provider.albumLoader.list.isEmpty,
                            header: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16, top: 16),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      "Album",
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AlbumListPage(
                                                      extraFilter: {
                                                        "search": searchKey
                                                      },
                                                      title: "Result in $searchKey",
                                                    )),
                                          );
                                        },
                                        child: Text(
                                          "More",
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            content: provider.albumLoader.list.map((album) {
                              var coverUrl = album.getCoverUrl();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text(
                                    album.name ?? "Unknown",
                                  ),
                                  subtitle: Text(
                                    album.getArtist("unknown"),
                                  ),
                                  leading: coverUrl != null
                                      ? Image.network(
                                    coverUrl,
                                    width: 64,
                                  )
                                      : Container(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: Icon(
                                        Icons.album_rounded,
                                        size: 48,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    AlbumPage.launch(
                                        context, album.id, cover: coverUrl,
                                        blurHash: album.blurHash);
                                  },
                                  onLongPress: () {
                                    HapticFeedback.selectionClick();
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            AlbumMetaInfo(
                                              album: album,
                                            ));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              );
                            })),
                        ...renderResultRow(
                            empty: provider.artistLoader.list.isEmpty,
                            header: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16, top: 16),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      "Artist",
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ArtistListPage(
                                                      extraFilter: {
                                                        "search": searchKey
                                                      },
                                                      title: "Result in $searchKey",
                                                    )),
                                          );
                                        },
                                        child: Text(
                                          "More",
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            content: provider.artistLoader.list.map((artist) {
                              var coverUrl = artist.getAvatarUrl();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text(
                                    artist.name ?? "",
                                  ),
                                  leading: coverUrl != null
                                      ? Image.network(
                                    coverUrl,
                                    width: 64,
                                  )
                                      : Container(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: Icon(
                                        Icons.person_rounded,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    ArtistPage.launch(context, artist.id);
                                  },
                                  onLongPress: () {
                                    HapticFeedback.selectionClick();
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            ArtistMetaInfo(
                                              artist: artist,
                                            ));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              );
                            })),
                        ...renderResultRow(
                            empty: provider.playlistLoader.list.isEmpty,
                            header: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16, top: 16),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      "Playlist",
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          PlaylistListPage.launch(context,
                                              extraFilter: {
                                                "name": searchKey
                                              }, title: "Result in $searchKey");
                                        },
                                        child: Text(
                                          "More",
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            content: provider.playlistLoader.list.map((playlist) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text(
                                    playlist.displayName,
                                  ),
                                  leading: Container(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: Icon(
                                        Icons.playlist_play_rounded,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    MusicListPage.launch(context,extraFilter: {
                                      "playlist": playlist.id.toString()
                                    }, title: playlist.displayName);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              );
                            })),
                        ...renderResultRow(
                            empty: provider.tagLoader.list.isEmpty,
                            header: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16, top: 16),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      "Tag",
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          TagListView.launch(context,
                                              extraFilter: {
                                                "search": searchKey
                                              }, title: "Result in $searchKey");
                                        },
                                        child: Text(
                                          "More",
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            content: provider.tagLoader.list.map((tag) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text(
                                    tag.displayName,
                                  ),
                                  leading: Container(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: Icon(
                                        Icons.bookmark_rounded,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    TagView.launch(context, tag.id?.toString());
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
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
