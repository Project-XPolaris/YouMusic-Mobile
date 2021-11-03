import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';

class MusicListProvider extends ChangeNotifier{
  final Map<String,String> extraFilter;
  MusicLoader loader = MusicLoader();

  MusicListProvider({required this.extraFilter});
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