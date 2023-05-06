import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';

class AlbumListProvider extends ChangeNotifier {
  final Map<String, String> extraFilter;
  AlbumLoader loader = AlbumLoader();
  AlbumFilter albumFilter = new AlbumFilter(order: "id desc");

  AlbumListProvider({required this.extraFilter});

  Map<String, String> _getExtraParam() {
    Map<String, String> extraParam = {};
    if (albumFilter.order == "random") {
      extraParam["random"] = "1";
    } else {
      extraParam["order"] = AlbumOrderMapping[albumFilter.order] ?? "id desc";
    }
    return extraParam;
  }

  loadData({force = false}) async {
    if (await loader.loadData(
        force: force, extraFilter: {..._getExtraParam(), ...extraFilter})) {
      notifyListeners();
    }
  }

  loadMore() async {
    if (await loader
        .loadMore(extraFilter: {..._getExtraParam(), ...extraFilter})) {
      notifyListeners();
    }
  }
}
