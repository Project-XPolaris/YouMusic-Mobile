import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album-list/album_list.dart';
import 'package:youmusic_mobile/ui/artist/provider.dart';
import 'package:youmusic_mobile/ui/components/item_album.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/ui/meta-navigation/music.dart';
import 'package:youmusic_mobile/ui/music-list/music_list.dart';
import 'package:collection/collection.dart';

class ArtistPage extends StatefulWidget {
  final int id;

  const ArtistPage({Key? key, required this.id}) : super(key: key);

  static launch(BuildContext context, int? artistId) {
    var id = artistId;
    if (id == null) {
      return;
    }
    Navigator.push(
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
    return ChangeNotifierProvider<ArtistProvider>(
        create: (_) => ArtistProvider(id),
        child: Consumer<ArtistProvider>(builder: (context, provider, child) {
          provider.loadData();
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            String? getPersonAvatar() {
              var url = provider.artist?.getAvatarUrl();
              if (url != null) {
                return url;
              }
              Album? album = provider.albumLoader.list
                  .firstWhereOrNull((album) => album.getCoverUrl() != null);
              if (album != null) {
                return album.getCoverUrl();
              }
              return null;
            }
            var coverUrl = getPersonAvatar();
            print(coverUrl);
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
                      backgroundColor: Colors.black,
                      flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          centerTitle: true,
                          stretchModes: [StretchMode.zoomBackground],
                          title: Container(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Text(provider.artist?.name ?? "Unknown",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                )),
                          ),
                          background: Stack(
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
                                          color: Colors.pink,
                                          child: Center(
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
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
                                      Colors.black
                                    ], // red to yellow
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ];
                },
                body: Container(
                  color: Colors.black,
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
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                GestureDetector(
                                  child: Text(
                                    "查看更多",
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                  onTap: () {
                                    var artistId =
                                        provider.artist?.id?.toString();
                                    if (artistId == null) {
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MusicListPage(
                                                extraFilter: {
                                                  "artist": artistId
                                                },
                                              )),
                                    );
                                  },
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Column(
                                children:
                                    (provider.musicLoader.list).map((music) {
                                  var musicCover = music.getCoverUrl();
                                  return ListTile(
                                      leading: AspectRatio(
                                        aspectRatio: 1,
                                        child: musicCover != null
                                            ? Image.network(
                                                musicCover,
                                                fit: BoxFit.cover,
                                                width: 64,
                                                height: 64,
                                              )
                                            : Container(
                                                color: Colors.pink,
                                                child: Center(
                                                  child: Icon(Icons.music_note),
                                                ),
                                              ),
                                      ),
                                      title: Text(
                                        music.title ?? "Unknown",
                                        style: TextStyle(color: Colors.white),
                                        softWrap: false,
                                      ),
                                      subtitle: Text(
                                        music.getAlbumName("Unknown"),
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                        softWrap: false,
                                      ),
                                      onTap: () {
                                        playProvider.playMusic(music,
                                            autoPlay: true);
                                      },
                                      onLongPress: () {
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
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Album",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                GestureDetector(
                                  child: Text(
                                    "查看更多",
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                  onTap: () {
                                    var artistId =
                                        provider.artist?.id?.toString();
                                    if (artistId == null) {
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AlbumListPage(
                                                extraFilter: {
                                                  "artist": artistId
                                                },
                                              )),
                                    );
                                  },
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Container(
                                height: 160,
                                child: provider.albumLoader.list.length > 0
                                    ? GridView.count(
                                        childAspectRatio: 13 / 9,
                                        scrollDirection: Axis.horizontal,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        crossAxisCount: 1,
                                        children: provider.albumLoader.list
                                            .map((album) {
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
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: PlayBar(),
            );
          });
        }));
  }
}
