import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/artist_loader.dart';

class ArtistTabProvider extends ChangeNotifier{
  ArtistLoader loader = ArtistLoader();
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