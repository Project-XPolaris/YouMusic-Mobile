part of 'add_playlist_dialog_bloc.dart';

class AddPlaylistDialogState extends Equatable {
  final List<Playlist> playlists;
  final String? inputName;
  const AddPlaylistDialogState({required this.playlists,this.inputName});
  copyWith({List<Playlist>? playlists,String? inputName}) {
    return AddPlaylistDialogState(playlists: playlists ?? this.playlists,inputName: inputName ?? this.inputName);
  }
  @override
  List<Object?> get props => [playlists,inputName];
}

class AddPlaylistDialogInitial extends AddPlaylistDialogState {
  AddPlaylistDialogInitial({required List<Playlist> playlists}) : super(playlists: const []);

  @override
  List<Object> get props => [];
}

