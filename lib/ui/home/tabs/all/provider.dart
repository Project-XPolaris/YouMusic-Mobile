import 'package:flutter/widgets.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';

class MusicTabProvider extends ChangeNotifier{
  MusicLoader loader = MusicLoader();
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