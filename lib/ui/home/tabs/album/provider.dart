import 'package:flutter/widgets.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';

class AlbumTabProvider extends ChangeNotifier{
  AlbumLoader loader = AlbumLoader();
  loadData() async {
    if (await loader.loadData()){
      notifyListeners();
    }
  }
  loadMore() async {
    if (await loader.loadMore()){
      notifyListeners();
    }
  }
}