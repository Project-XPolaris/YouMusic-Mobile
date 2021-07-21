import 'package:flutter/widgets.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';
import 'package:youmusic_mobile/ui/components/music-filter.dart';
const MusicOrderMapping = {
  "id asc": "id",
  "id desc": "-id",
  "title asc": "title",
  "title desc": "-title",
};
class MusicTabProvider extends ChangeNotifier{
  MusicLoader loader = MusicLoader();
  MusicFilter musicFilter = new MusicFilter(order: "id desc");
  _getExtraParam() {
    return {
      "order":MusicOrderMapping[musicFilter.order]
    };
  }
  loadData({force = false}) async {
    if (await loader.loadData(force: force,extraFilter: _getExtraParam())){
      notifyListeners();
    }
  }
  loadMore() async {
    if (await loader.loadMore(extraFilter: _getExtraParam())){
      notifyListeners();
    }
  }
}