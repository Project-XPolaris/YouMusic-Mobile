import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album-list/provider.dart';
import 'package:youmusic_mobile/ui/album/album.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/utils/listview.dart';

class AlbumListPage extends StatelessWidget {
  final Map<String, String> extraFilter;
  final String title;
  const AlbumListPage({Key? key, this.extraFilter = const {},this.title = "Album List"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlbumListProvider>(
        create: (_) => AlbumListProvider(extraFilter: extraFilter),
        child: Consumer<AlbumListProvider>(builder: (context, provider, child) {
          return Consumer<PlayProvider>(
              builder: (context, playProvider, child) {
            provider.loadData();
            var _controller = createLoadMoreController(provider.loadMore);
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
                backgroundColor: Colors.transparent,
              ),
              body: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: ListView(
                  controller: _controller,
                  children:provider.loader.list.map((album) {
                    var coverUrl = album.getCoverUrl();
                    return ListTile(
                      title: Text(album.name ?? "Unknown",style: TextStyle(),),
                      subtitle: Text(album.getArtist("Unknown"),style: TextStyle(fontSize: 12)),
                      leading: AspectRatio(
                        aspectRatio: 1,
                        child: coverUrl != null ? Image.network(coverUrl,fit: BoxFit.cover,) : CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                            child:Icon(
                                Icons.album,
                                color: Theme.of(context).colorScheme.onSecondaryContainer
                            )
                        ),
                      ),
                      onTap: () {
                        AlbumPage.launch(context, album.id,cover: coverUrl,blurHash: album.blurHash);
                      },
                      onLongPress: () {
                        HapticFeedback.selectionClick();
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => AlbumMetaInfo(
                              album: album,
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
