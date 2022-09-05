import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';

import '../../../api/entites.dart';
import '../../../api/loader/playlist_loader.dart';

part 'playlist_list_event.dart';
part 'playlist_list_state.dart';

class PlaylistListBloc extends Bloc<PlaylistListEvent, PlaylistListState> {
  PlaylistLoader loader = new PlaylistLoader();
  PlaylistListBloc() : super(PlaylistListInitial()) {
    on<LoadEvent>((event, emit) async {
      await loader.loadData(force: event.force);
      emit(state.copyWith(list: loader.list));
    });
    on<LoadMoreEvent>((event, emit) async {
      await loader.loadMore();
      emit(state.copyWith(list: loader.list));
    });
  }
}
