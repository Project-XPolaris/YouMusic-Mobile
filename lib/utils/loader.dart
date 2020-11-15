import 'package:youmusic_mobile/api/entites.dart';

abstract class ApiDataLoader<T> {
  List<T> list = [];
  bool firstLoad = true;
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;
  int pageSize = 20;
  Map<String,String> queryParams = {
    "page":"1",
    "pageSize":"20"
  };
  Future<bool> loadData() async{
    if (!firstLoad || isLoading || !hasMore){
      return false;
    }
    firstLoad = false;
    isLoading = true;
    var response = await fetchData(queryParams);
    list = response.data;
    hasMore = list.length < response.count;
    isLoading = false;
    return true;
  }

  Future<bool> loadMore() async{

    if (isLoading || !hasMore){
      return false;
    }
    print("==================");
    isLoading = true;
    queryParams["page"] = (page + 1).toString();
    var response = await fetchData(queryParams);
    list.addAll(response.data);
    print(list.length);
    print(response.count);
    hasMore = list.length < response.count;
    print(hasMore);
    page += 1;
    isLoading = false;
    return true;
  }
  Future<ListResponseWrap<T>> fetchData(Map<String,String> params);
}