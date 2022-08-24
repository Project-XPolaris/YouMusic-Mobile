import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/utils/loader.dart';

class AlbumLoader extends ApiDataLoader<Album>{
  @override
  Future<ListResponseWrap<Album>> fetchData(Map<String,String> params) {
    return ApiClient().fetchAlbum(params);
  }
}
const AlbumOrderMapping = {
  "id asc": "id",
  "id desc": "-id",
  "name asc": "name",
  "name desc": "-name",
  "random": "random"
};
class AlbumFilter {
  String order;
  String? tag;
  AlbumFilter({required this.order,this.tag});
  Map<String,String> toParam({Map<String,String>? extra}) {
    Map<String,String> param = {};
    if (order == "random") {
      param["random"] = "1";
    }else{
      param["order"] = AlbumOrderMapping[order] ?? "id desc";
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