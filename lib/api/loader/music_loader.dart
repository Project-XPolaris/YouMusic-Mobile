import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/utils/loader.dart';

class MusicLoader extends ApiDataLoader<Music> {
  @override
  Future<ListResponseWrap<Music>> fetchData(Map<String,String> params) {
    return ApiClient().fetchMusicList(params);
  }
}