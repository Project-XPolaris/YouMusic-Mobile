import 'package:flutter/widgets.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';

class AlbumTabProvider extends ChangeNotifier{
  AlbumLoader loader = AlbumLoader();
  loadData({force = false}) async {
    if (await loader.loadData(force: force)){
      notifyListeners();
    }
  }
  loadMore() async {
    if (await loader.loadMore()){
      notifyListeners();
    }
  }
}