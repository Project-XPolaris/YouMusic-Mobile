
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../api/client.dart';
import '../../../api/entites.dart';
import '../../../api/loader/tag_loader.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final int id;
  final TagLoader tagLoader = TagLoader();
  AlbumBloc({required this.id}) : super(AlbumInitial()) {
    on<AlbumInitialEvent>((event, emit) async {
      await loadAlbum(event, emit);
      await loadTags(event, emit);
      await checkIsFollow(event, emit);
    });
    on<FollowEvent>((event, emit) async {
      BaseResponse result = await ApiClient().followAlbum(id);
      if (result.success) {
        await checkIsFollow(event, emit);
      }
    });
    on<UnFollowEvent>((event, emit) async {
      BaseResponse result = await ApiClient().unFollowAlbum(id);
      if (result.success) {
        await checkIsFollow(event, emit);
      }
    });
  }
  checkIsFollow(event, emit) async {
    var response = await ApiClient().fetchAlbum({"id": id.toString(), "follow": "1"});
    bool isFollow = response.data.length > 0;
    emit(state.copyWith(isFollow: isFollow));
  }
  loadTags(event, emit) async {
    await tagLoader.loadData(extraFilter: {"album": id.toString()});
    emit(state.copyWith(tags: tagLoader.list));
  }
  loadAlbum(event, emit) async {
    var album = await ApiClient().fetchAlbumById(id.toString());
    emit(state.copyWith(album: album));
  }
}
