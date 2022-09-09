import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/loader/playlist_loader.dart';
import 'package:youmusic_mobile/ui/meta-navigation/add-playlist/view/dialog.dart';

import '../../../../api/entites.dart';

part 'add_playlist_dialog_event.dart';

part 'add_playlist_dialog_state.dart';

class AddPlaylistDialogBloc
    extends Bloc<AddPlaylistDialogEvent, AddPlaylistDialogState> {
  final PlaylistLoader loader = new PlaylistLoader();

  AddPlaylistDialogBloc() : super(AddPlaylistDialogInitial(playlists: [])) {
    on<LoadDataEvent>((event, emit) async {
      await loader.loadData();
      emit(state.copyWith(playlists: loader.list));
    });
    on<CreateAndAddMusic>((event, emit) async {
      Playlist playlist = await ApiClient().createPlaylist(event.name);
      if (playlist.id != null) {
        await ApiClient().addMusicToPlaylist(playlist.id!, [event.musicId]);
      }
    });
    on<InputNameChanged>((event, emit) {
      emit(state.copyWith(inputName: event.name));
    });
  }
}
