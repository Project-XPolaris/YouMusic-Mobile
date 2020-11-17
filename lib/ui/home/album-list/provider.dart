import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';

class AlbumListProvider extends ChangeNotifier{
  final Map<String,String> extraFilter;
  AlbumLoader loader = AlbumLoader();
  AlbumListProvider({this.extraFilter});
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