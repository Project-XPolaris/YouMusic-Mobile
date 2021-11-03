import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/artist-list/provider.dart';
import 'package:youmusic_mobile/ui/artist/artist.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/artist.dart';
import 'package:youmusic_mobile/utils/listview.dart';

class ArtistListPage extends StatelessWidget {
  final Map<String, String> extraFilter;
  final String title;
  const ArtistListPage({Key? key, this.extraFilter = const {},this.title = "Artist List"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArtistListProvider>(
        create: (_) => ArtistListProvider(extraFilter: extraFilter),
        child: Consumer<ArtistListProvider>(builder: (context, provider, child) {
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            provider.loadData();
            var _controller = createLoadMoreController(provider.loadMore);
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text(title, style: TextStyle(color: Colors.white),),
                backgroundColor: Colors.transparent,
              ),
              body: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: ListView(
                  controller: _controller,
                  children:provider.loader.list.map((artist) {
                    var artistCoverUrl = artist.getAvatarUrl();
                    return ListTile(
                      title: Text(artist.name ?? "",style: TextStyle(color: Colors.white),),
                      leading: AspectRatio(
                        aspectRatio: 1,
                        child: artistCoverUrl != null ? Image.network(artistCoverUrl,fit: BoxFit.cover,):Container(),
                      ),
                      onTap: () {
                        var artistId = artist.id;
                        if (artistId == null) {
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ArtistPage(id: artistId)),
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
                    );
                  }).toList(),
                ),
              ),
              bottomNavigationBar: PlayBar(),
            );
          });
        }));
  }
}
