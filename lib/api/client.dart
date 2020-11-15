import 'package:dio/dio.dart';
import '../config.dart';
import 'entites.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static Dio _dio = new Dio();
  factory ApiClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest:(RequestOptions options) async {
        options.baseUrl = ApplicationConfig.apiUrl;
        return options; //continue
      },
    ));
    return _instance;
  }

  Future<ListResponseWrap<Album>> fetchAlbum(Map<String,String> params) async{
    var response = await _dio.get("/album",queryParameters: params);
    ListResponseWrap<Album> responseBody = ListResponseWrap.fromJson(response.data, (data) => Album.fromJson(data));
    return responseBody;
  }

  Future<ListResponseWrap<Artist>> fetchArtist(Map<String,String> params) async {
    var response = await _dio.get("/artist",queryParameters: params);
    ListResponseWrap<Artist> responseBody = ListResponseWrap.fromJson(response.data, (data) => Artist.fromJson(data));
    return responseBody;
  }

  Future<ListResponseWrap<Music>> fetchMusicList(Map<String,String> params) async {
    var response = await _dio.get("/music",queryParameters: params);
    ListResponseWrap<Music> responseBody = ListResponseWrap.fromJson(response.data, (data) => Music.fromJson(data));
    return responseBody;
  }
  ApiClient._internal();
}