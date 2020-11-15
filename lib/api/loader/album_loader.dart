import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/utils/loader.dart';

class AlbumLoader extends ApiDataLoader<Album>{
  @override
  Future<ListResponseWrap<Album>> fetchData(Map<String,String> params) {
    return ApiClient().fetchAlbum(params);
  }
}