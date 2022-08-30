import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';

import '../../../api/client.dart';
import '../../../api/entites.dart';

part 'tag_event.dart';
part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  final String id;
  final AlbumLoader albumLoader = new AlbumLoader();
  final MusicLoader musicLoader = new MusicLoader();
  Map<String,String> get extraFilter{
    return {
      "tag": id,
    };
  }
  TagBloc({required this.id}) : super(TagInitial()) {
    on<TabChangeEvent>((event, emit) {
      emit(state.copyWith(idx: event.idx));
    });
    on<InitEvent>((event, emit) async {
      Tag tag = await ApiClient().fetchTagById(id.toString());
      emit(state.copyWith(tag: tag));
      await albumLoader.loadData(extraFilter: state.albumFilter.toParam(extra:extraFilter));
      emit(state.copyWith(albumList: albumLoader.list));
      await musicLoader.loadData(extraFilter: state.musicFilter.toParam(extra:extraFilter));
      emit(state.copyWith(musicList: musicLoader.list));
      await checkIsFollow(event, emit);
    });
    on<AlbumFilterUpdatedEvent>((event, emit) async {
      await albumLoader.loadData(extraFilter: event.albumFilter.toParam(extra:extraFilter),force: true);
      emit(state.copyWith(albumList: albumLoader.list));
    });
    on<MusicFilterUpdatedEvent>((event, emit) async {
      await musicLoader.loadData(extraFilter: event.musicFilter.toParam(extra:extraFilter),force: true);
      emit(state.copyWith(musicList: musicLoader.list));
    });
    on<LoadMoreAlbumEvent>((event, emit) async {
      await albumLoader.loadMore();
      emit(state.copyWith(albumList: albumLoader.list));
    });
    on<LoadMoreMusicEvent>((event, emit) async {
      await musicLoader.loadMore();
      emit(state.copyWith(musicList: musicLoader.list));
    });
    on<FollowEvent>((event, emit) async {
      BaseResponse result = await ApiClient().followTag(int.parse(id));
      if (result.success) {
        await checkIsFollow(event, emit);
      }
    });
    on<UnFollowEvent>((event, emit) async {
      BaseResponse result = await ApiClient().unFollowTag(int.parse(id));
      if (result.success) {
        await checkIsFollow(event, emit);
      }
    });
  }
  checkIsFollow(event, emit)async{
    var result = await ApiClient().fetchTagList({
      "ids": id.toString(),
      "follow":"1"
    });
    emit(state.copyWith(isFollow: result.data.length > 0));
  }

}
