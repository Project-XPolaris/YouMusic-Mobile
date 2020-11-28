import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/config.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/artist/provider.dart';
import 'package:youmusic_mobile/ui/components/item_album.dart';
import 'package:youmusic_mobile/ui/home/album-list/album_list.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/music-list/music_list.dart';

class ArtistPage extends StatefulWidget {
  final int id;

  const ArtistPage({Key key, this.id}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState(id);
}

class _ArtistPageState extends State<ArtistPage> {
  var headAlpha = 0;
  final int id;

  _ArtistPageState(this.id);

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (pixel + 25 <= 255) {
        setState(() {
          headAlpha = pixel.toInt() + 25;
        });
      }
      print(pixel);
    });
    return ChangeNotifierProvider<ArtistProvider>(
        create: (_) => ArtistProvider(id),
        child: Consumer<ArtistProvider>(builder: (context, provider, child) {
          provider.loadData();
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
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
                          title: Text(provider.artist?.name ?? "Unknown",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              )),
                          background: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                child: Image.network(
                                  provider.artist?.getAvatarUrl() ?? "",
                                  fit: BoxFit.cover,
                                  scale: 2,
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MusicListPage(
                                                extraFilter: {
                                                  "artist": provider.artist.id
                                                      .toString()
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
                                children: (provider.musicLoader.list ?? [])
                                    .map((music) {
                                  return ListTile(
                                    leading: AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.network(music.getCoverUrl(),fit: BoxFit.cover,width: 64,height: 64,),
                                    ),
                                    title: Text(
                                      music.title,
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
                                  );
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AlbumListPage(
                                                extraFilter: {
                                                  "artist": provider.artist.id
                                                      .toString()
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
