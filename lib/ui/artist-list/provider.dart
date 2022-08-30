import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/artist_loader.dart';

class ArtistListProvider extends ChangeNotifier{
  final Map<String,String> extraFilter;
  ArtistFilter artistFilter = new ArtistFilter(order: "id desc");
  ArtistLoader loader = ArtistLoader();
  ArtistListProvider({required this.extraFilter});
  loadData({bool force = false}) async {
    if (await loader.loadData(extraFilter:artistFilter.toParam(extra: extraFilter),force: force)){
      notifyListeners();
    }
  }
  loadMore() async {
    if (await loader.loadMore(extraFilter:artistFilter.toParam(extra: extraFilter))){
      notifyListeners();
    }
  }
  onUnFollow(int artistId){
    loader.list = loader.list.where((element) => element.id != artistId).toList();
    notifyListeners();
  }
}