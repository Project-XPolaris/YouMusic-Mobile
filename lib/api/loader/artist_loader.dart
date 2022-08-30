import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/utils/loader.dart';

class ArtistLoader extends ApiDataLoader<Artist> {
  @override
  Future<ListResponseWrap<Artist>> fetchData(Map<String,String> params) {
    return ApiClient().fetchArtist(params);
  }
}
const ArtistOrderMapping = {
  "id asc": "id",
  "id desc": "-id",
  "name asc": "name",
  "name desc": "-name",
};
class ArtistFilter {
  String order;
  ArtistFilter({required this.order});
  Map<String,String> toParam({Map<String,String>? extra}) {
    Map<String,String> param = {};
    if (order == "random") {
      param["random"] = "1";
    }else{
      param["order"] = ArtistOrderMapping[order] ?? "-id";
    }
    if (extra != null) {
      param.addAll(extra);
    }

    return param;
  }
}