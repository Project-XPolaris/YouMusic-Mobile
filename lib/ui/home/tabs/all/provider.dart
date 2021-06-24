import 'package:flutter/widgets.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';

class MusicTabProvider extends ChangeNotifier{
  MusicLoader loader = MusicLoader();
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