import 'package:flutter/widgets.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';
import 'package:youmusic_mobile/ui/components/album-filter.dart';



class AlbumTabProvider extends ChangeNotifier {
  AlbumLoader loader = AlbumLoader();
  AlbumFilter albumFilter = new AlbumFilter(order: "id desc");

  Map<String,String> _getExtraParam() {
    Map<String,String> extraParam = {};
    if (albumFilter.order == "random") {
      extraParam["random"] = "1";
    }else{
      extraParam["order"] = AlbumOrderMapping[albumFilter.order] ?? "id desc";
    }
    return extraParam;
  }

  loadData({force = false}) async {
    if (await loader.loadData(force: force, extraFilter: _getExtraParam())) {
      notifyListeners();
    }
  }

  loadMore() async {
    if (await loader.loadMore(extraFilter: _getExtraParam())) {
      notifyListeners();
    }
  }
}
