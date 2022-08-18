import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';

import '../../api/client.dart';
import '../../api/entites.dart';

class TagProvider extends ChangeNotifier {
  final String id;
  TagProvider(this.id);
  Tag? tag;
  bool first = true;
  List<Album> albums = [];
  int tabIdx = 0;
  AlbumLoader albumLoader = AlbumLoader();
  MusicLoader musicLoader = MusicLoader();
  Future<void> loadData() async {
    if (!first) {
      return;
    }
    first = false;
    tag = await ApiClient().fetchTagById(id);
    await albumLoader.loadData(extraFilter: {"tag": id});
    await musicLoader.loadData(extraFilter: {"tag": id});
    notifyListeners();
  }
  changeTab(int idx) {
    tabIdx = idx;
    notifyListeners();
  }
  loadMoreAlbums() async {
    await albumLoader.loadMore();
    notifyListeners();
  }
  loadMoreMusics() async {
    await musicLoader.loadMore();
    notifyListeners();
  }
  String get displayTagName => tag?.name ?? "Unknown";

}