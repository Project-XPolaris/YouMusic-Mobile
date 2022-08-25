import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/artist_loader.dart';

class ArtistTabProvider extends ChangeNotifier{
  ArtistLoader loader = ArtistLoader();
  ArtistFilter artistFilter = new ArtistFilter(order:"id desc");

  loadData({force = false}) async {
    if (await loader.loadData(force: force,extraFilter: artistFilter.toParam())){
      notifyListeners();
    }
  }
  loadMore() async {
    if (await loader.loadMore( extraFilter: artistFilter.toParam())){
      notifyListeners();
    }
  }
}