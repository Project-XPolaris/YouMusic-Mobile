import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/utils/loader.dart';

class ArtistLoader extends ApiDataLoader<Artist> {
  @override
  Future<ListResponseWrap<Artist>> fetchData(Map<String,String> params) {
    return ApiClient().fetchArtist(params);
  }
}