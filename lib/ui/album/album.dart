import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album/provider.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/music.dart';

class AlbumPage extends StatelessWidget {
  final int id;

  const AlbumPage({Key? key, required this.id}) : super(key: key);

  static launch(BuildContext context,int? albumId) {
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlbumProvider>(
        create: (_) => AlbumProvider(id),
        child: Consumer<AlbumProvider>(builder: (context, provider, child) {
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            var albumCoverUrl = provider.album?.getCoverUrl();
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: FutureBuilder(
                future: provider.loadData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 64, right: 64, top: 16),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: Text(
                            provider.album?.name ?? "unknown",
                            style: TextStyle(color: Colors.pink, fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 64),
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
                          padding: EdgeInsets.only(bottom: 32),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "All music",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                        ...(provider.album?.music ?? []).map((music) {
                          return ListTile(
                              minVerticalPadding: 16,
                              title: Text(
                                music.title ?? "No title",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(music.getArtistString("Unknown"),
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 12)),
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
                        })
                      ],
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
