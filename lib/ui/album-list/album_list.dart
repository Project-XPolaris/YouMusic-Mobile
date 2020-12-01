import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';
import 'package:youmusic_mobile/ui/album-list/provider.dart';
import 'package:youmusic_mobile/ui/album/album.dart';
import 'package:youmusic_mobile/ui/components/item_album_list.dart';
import 'package:youmusic_mobile/ui/home/play_bar.dart';
import 'package:youmusic_mobile/ui/meta-navigation/album.dart';
import 'package:youmusic_mobile/utils/listview.dart';

class AlbumListPage extends StatelessWidget {
  final Map<String, String> extraFilter;

  const AlbumListPage({Key key, this.extraFilter}) : super(key: key);

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
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text("Album List", style: TextStyle(color: Colors.white),),
                backgroundColor: Colors.transparent,
              ),
              body: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: ListView(
                  controller: _controller,
                  children:provider.loader.list.map((album) {
                    return ListTile(
                      title: Text(album.name,style: TextStyle(color: Colors.white),),
                      subtitle: Text(album.getArtist("Unknown"),style: TextStyle(color: Colors.white54,fontSize: 12)),
                      leading: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(album.getCoverUrl(),fit: BoxFit.cover,),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AlbumPage(id: album.id,)),
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
