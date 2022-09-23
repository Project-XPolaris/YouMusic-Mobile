import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';

import '../../../api/entites.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final MusicLoader musicLoader = new MusicLoader();
  PlaylistBloc({required Playlist playlist}) : super(PlaylistInitial(playlist: playlist)) {
    on<LoadMusicEvent>((event, emit) async {
      if (await musicLoader.loadData(force: event.force, extraFilter: {"playlist": state.playlist.id.toString(),"pageSize":"10000"})) {
        // get first music album cover
        String? coverUrl = null;
        if (musicLoader.list.length > 0) {
          coverUrl = musicLoader.list.first.album?.coverUrl;
        }
        emit(state.copyWith(musics: musicLoader.list,coverUrl: coverUrl));
      }
    });
    on<LoadMoreMusicEvent>((event, emit) async {
      if (await musicLoader.loadMore()) {
        emit(state.copyWith(musics: musicLoader.list));
      }
    });
  }
}
