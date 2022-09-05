import 'package:youmusic_mobile/utils/loader.dart';

import '../client.dart';
import '../entites.dart';

class PlaylistLoader extends ApiDataLoader<Playlist> {
  @override
  Future<ListResponseWrap<Playlist>> fetchData(Map<String, String> params) {
    return ApiClient().fetchPlaylistList(params);
  }
}

const PlaylistOrderMapping = {
  "id asc": "id",
  "id desc": "-id",
  "title asc": "title",
  "title desc": "-title",
};

class PlaylistFilter {
  String order;

  PlaylistFilter({required this.order});

  Map<String, String> toParam({Map<String, String>? extra}) {
    Map<String, String> param = {};
    if (order == "random") {
      param["random"] = "1";
    } else {
      param["order"] = PlaylistOrderMapping[order] ?? "id desc";
    }
    if (extra != null) {
      param.addAll(extra);
    }
    return param;
  }
}
