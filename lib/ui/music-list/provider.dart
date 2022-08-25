import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';

class MusicListProvider extends ChangeNotifier{
  final Map<String,String> extraFilter;
  MusicLoader loader = MusicLoader();
  MusicFilter filter = new MusicFilter(order: "id desc");
  MusicListProvider({required this.extraFilter});
  Map<String,String> get _requestParam{
    Map<String,String> param = {};
    param.addAll(extraFilter);
    param.addAll(filter.toParam());
    return param;
  }

  loadData({force:false}) async {
    if (await loader.loadData(extraFilter:_requestParam,force: force)){
      notifyListeners();
    }
  }
  loadMore() async {
    if (await loader.loadMore(extraFilter:_requestParam)){
      notifyListeners();
    }
  }
}