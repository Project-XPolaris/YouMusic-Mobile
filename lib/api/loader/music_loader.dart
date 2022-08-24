import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/utils/loader.dart';

class MusicLoader extends ApiDataLoader<Music> {
  @override
  Future<ListResponseWrap<Music>> fetchData(Map<String, String> params) {
    return ApiClient().fetchMusicList(params);
  }
}

const MusicOrderMapping = {
  "id asc": "id",
  "id desc": "-id",
  "title asc": "title",
  "title desc": "-title",
};

class MusicFilter {
  String order;
  String? tag;

  MusicFilter({required this.order, this.tag});

  Map<String, String> toParam({Map<String, String>? extra}) {
    Map<String, String> param = {};
    if (order == "random") {
      param["random"] = "1";
    } else {
      param["order"] = MusicOrderMapping[order] ?? "id desc";
    }
    var paramTag = tag;
    if (paramTag != null) {
      param["tag"] = paramTag;
    }
    if (extra != null) {
      param.addAll(extra);
    }

    return param;
  }
}
