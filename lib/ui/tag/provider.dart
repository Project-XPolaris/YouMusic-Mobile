import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';
import 'package:youmusic_mobile/ui/components/album-filter.dart';

import '../../api/client.dart';
import '../../api/entites.dart';

class TagProvider extends ChangeNotifier {
  final String id;

  TagProvider(this.id){
    albumFilter.tag = id;
    musicFilter.tag = id;
  }

  Tag? tag;
  bool first = true;
  List<Album> albums = [];
  int tabIdx = 0;
  AlbumLoader albumLoader = AlbumLoader();
  MusicLoader musicLoader = MusicLoader();
  AlbumFilter albumFilter = new AlbumFilter(order: "id desc");
  MusicFilter musicFilter = new MusicFilter(order: "id desc");

  Future<void> loadData() async {
    if (!first) {
      return;
    }
    first = false;
    tag = await ApiClient().fetchTagById(id);
    await albumLoader.loadData(extraFilter: albumFilter.toParam());
    await musicLoader.loadData(extraFilter: musicFilter.toParam());
    notifyListeners();
  }

  Future<void> forceReloadAlbum() async {
    await albumLoader
        .loadData(force: true, extraFilter:albumFilter.toParam());
    notifyListeners();
  }

  Future<void> forceReloadMusic() async {
    await musicLoader
        .loadData(force: true, extraFilter:musicFilter.toParam());
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
