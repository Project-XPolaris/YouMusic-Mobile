import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';

import '../../../api/entites.dart';
import '../../../api/loader/album_loader.dart';

part 'genre_event.dart';

part 'genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final String genreId;
  AlbumLoader _albumLoader = AlbumLoader();
  MusicLoader _musicLoader = MusicLoader();

  GenreBloc({required this.genreId}) : super(GenreInitial()) {
    on<InitEvent>((event, emit) async {
        checkIsFollow(event, emit);
      },
    );
    on<LoadAlbumEvent>((event, emit) async {
      await _albumLoader.loadData(
          force: event.force, extraFilter: state.albumFilter.toParam(extra: {"genre":genreId.toString()}));
      emit(state.copyWith(albumList: [..._albumLoader.list]));
    });
    on<LoadMoreAlbumEvent>((event, emit) async {
      if (await _albumLoader.loadMore(
          extraFilter: state.albumFilter.toParam(extra: {"genre":genreId.toString()}))) {
        emit(state.copyWith(albumList: [..._albumLoader.list]));
      }
    });
    on<LoadMusicEvent>((event, emit) async {
      await _musicLoader.loadData(
          force: event.force, extraFilter: state.musicFilter.toParam(extra: {"genre":genreId.toString()}));
      emit(state.copyWith(musicList: [..._musicLoader.list]));
    });
    on<LoadMoreMusicEvent>((event, emit) async {
      if (await _musicLoader.loadMore(
          extraFilter: state.musicFilter.toParam(extra: {"genre":genreId.toString()}))) {
        emit(state.copyWith(musicList: [..._musicLoader.list]));
      }
    });
    on<UpdateAlbumFilterEvent>((event, emit) async {
      await _albumLoader.loadData(
          force: true, extraFilter: event.updatedFilter.toParam(extra: {"genre":genreId.toString()}));
      emit(state.copyWith(
          albumList: [..._albumLoader.list], albumFilter: event.updatedFilter));
    });
    on<UpdateMusicFilterEvent>((event, emit) async {
      await _musicLoader.loadData(
          force: true, extraFilter: event.updatedFilter.toParam(extra: {"genre":genreId.toString()}));
      emit(state.copyWith(
          musicList: [..._musicLoader.list], musicFilter: event.updatedFilter));
    });

    on<TabIndexChangeEvent>((event, emit) async {
      emit(state.copyWith(index: event.index));
    });
    on<FollowEvent>((event, emit) async {
      await ApiClient().followGenre(int.parse(genreId));
      emit(state.copyWith(isFollow: true));
    });
    on<UnFollowEvent>((event, emit) async {
      await ApiClient().unFollowGenre(int.parse(genreId));
      emit(state.copyWith(isFollow: false));
    });
  }
  checkIsFollow(event, emit)async{
    var result = await ApiClient().fetchGenreList({
      "ids":genreId,
      "follow":"1"
    });
    if(result.data.isNotEmpty){
      emit(state.copyWith(isFollow: true));
    }
  }
}
