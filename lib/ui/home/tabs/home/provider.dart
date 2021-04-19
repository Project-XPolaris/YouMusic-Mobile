import 'package:flutter/widgets.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';
import 'package:youmusic_mobile/api/loader/artist_loader.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';

class HomeTabProvider extends ChangeNotifier{
  ArtistLoader artistLoader = ArtistLoader();
  AlbumLoader albumLoader = AlbumLoader();
  MusicLoader musicLoader = MusicLoader();
  Future<void> loadData({force = false}) async {
    if (await albumLoader.loadData(force: force)){
      notifyListeners();
    }
    if (await artistLoader.loadData(force: force)){
      notifyListeners();
    }
    if (await musicLoader.loadData(force: force)){
      notifyListeners();
    }
  }
}