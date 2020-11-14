import 'package:youmusic_mobile/api/entites.dart';

abstract class ApiDataLoader<T> {
  List<T> list = [];
  bool firstLoad = true;
  Future<bool> loadData() async{
    if (!firstLoad){
      return false;
    }
    firstLoad = false;
    var response = await fetchData();
    list = response.data;
    return true;
  }
  Future<ListResponseWrap<T>> fetchData();
}