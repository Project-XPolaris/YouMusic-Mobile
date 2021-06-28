import 'package:flutter/widgets.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';
import 'package:youmusic_mobile/ui/components/album-filter.dart';

const AlbumOrderMapping = {
  "id asc": "id",
  "id desc": "-id",
  "name asc": "name",
  "name desc": "-name",
};

class AlbumTabProvider extends ChangeNotifier {
  AlbumLoader loader = AlbumLoader();
  AlbumFilter albumFilter = new AlbumFilter("id desc");

  _getExtraParam() {
    return {
      "order":AlbumOrderMapping[albumFilter.order]
    };
  }

  loadData({force = false}) async {
    if (await loader.loadData(force: force, extraFilter: _getExtraParam())) {
      notifyListeners();
    }
  }

  loadMore() async {
    if (await loader.loadMore(extraFilter:_getExtraParam())) {
      notifyListeners();
    }
  }
}