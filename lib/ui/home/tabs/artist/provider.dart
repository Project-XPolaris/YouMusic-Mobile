import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/artist_loader.dart';
import 'package:youmusic_mobile/ui/components/artist-filter.dart';
const ArtistOrderMapping = {
  "id asc": "id",
  "id desc": "-id",
  "name asc": "name",
  "name desc": "-name",
};
class ArtistTabProvider extends ChangeNotifier{
  ArtistLoader loader = ArtistLoader();
  ArtistFilter artistFilter = new ArtistFilter(order:"id desc");

  _getExtraParam() {
    return {
      "order":ArtistOrderMapping[artistFilter.order]
    };
  }
  loadData({force = false}) async {
    if (await loader.loadData(force: force,extraFilter: _getExtraParam())){
      notifyListeners();
    }
  }
  loadMore() async {
    if (await loader.loadMore( extraFilter: _getExtraParam())){
      notifyListeners();
    }
  }
}