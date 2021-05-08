import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/artist_loader.dart';

class ArtistListProvider extends ChangeNotifier{
  final Map<String,String> extraFilter;
  ArtistLoader loader = ArtistLoader();
  ArtistListProvider({this.extraFilter});
  loadData() async {
    if (await loader.loadData(extraFilter:extraFilter)){
      notifyListeners();
    }
  }
  loadMore() async {
    if (await loader.loadMore(extraFilter:extraFilter)){
      notifyListeners();
    }
  }
}