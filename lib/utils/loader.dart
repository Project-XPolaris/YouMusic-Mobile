import 'package:youmusic_mobile/api/entites.dart';

abstract class ApiDataLoader<T> {
  List<T> list = [];
  bool firstLoad = true;
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;
  int pageSize = 20;
  _reset(){
    page = 1;
    pageSize = 20;
    hasMore = true;
    list = [];
  }
  Map<String,String> _getQueryParam(){
    return {
      "page":page.toString(),
      "pageSize":pageSize.toString()
    };
  }
  Future<bool> loadData({Map<String,String> extraFilter,bool force = false}) async{
    if (!force && ( !firstLoad || isLoading || !hasMore )){
      return false;
    }
    firstLoad = false;
    isLoading = true;
    _reset();
    Map<String,String> params = _getQueryParam();
    if (extraFilter != null) {
      params.addAll(extraFilter);
    }
    var response = await fetchData(params);
    list = response.data;
    hasMore = list.length < response.count;
    isLoading = false;
    return true;
  }

  Future<bool> loadMore({Map<String,String> extraFilter}) async{
    if (isLoading || !hasMore){
      return false;
    }
    isLoading = true;
    page += 1;
    Map<String,String> params = _getQueryParam();
    if (extraFilter != null) {
      params.addAll(extraFilter);
    }
    var response = await fetchData(params);
    list.addAll(response.data);
    hasMore = list.length < response.count;
    isLoading = false;
    return true;
  }
  Future<ListResponseWrap<T>> fetchData(Map<String,String> params);
}