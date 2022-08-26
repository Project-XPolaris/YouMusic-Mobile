import '../../utils/loader.dart';
import '../client.dart';
import '../entites.dart';

class GenreLoader extends ApiDataLoader<Genre> {
  @override
  Future<ListResponseWrap<Genre>> fetchData(Map<String, String> params) {
    return ApiClient().fetchGenreList(params);
  }
}

const GenreOrderMapping = {
  "id asc": "id",
  "id desc": "-id",
  "name asc": "name",
  "name desc": "-name",
};

class GenreFilter {
  String order;

  GenreFilter({required this.order});

  Map<String, String> toParam({Map<String, String>? extra}) {
    Map<String, String> param = {};
    if (order == "random") {
      param["random"] = "1";
    } else {
      param["order"] = GenreOrderMapping[order] ?? "-id";
    }
    if (extra != null) {
      param.addAll(extra);
    }

    return param;
  }
}