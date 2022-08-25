import '../../utils/loader.dart';
import '../client.dart';
import '../entites.dart';

class TagLoader extends ApiDataLoader<Tag> {
  @override
  Future<ListResponseWrap<Tag>> fetchData(Map<String, String> params) {
    return ApiClient().fetchTagList(params);
  }
}

const TagOrderMapping = {
  "id asc": "id",
  "id desc": "-id",
  "name asc": "name",
  "name desc": "-name",
};

class TagFilter {
  String order;

  TagFilter({required this.order});

  Map<String, String> toParam({Map<String, String>? extra}) {
    Map<String, String> param = {};
    if (order == "random") {
      param["random"] = "1";
    } else {
      param["order"] = TagOrderMapping[order] ?? "-id";
    }
    if (extra != null) {
      param.addAll(extra);
    }

    return param;
  }
}