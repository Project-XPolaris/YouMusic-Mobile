part of 'playlist_bloc.dart';

class PlaylistState extends Equatable {
  final Playlist playlist;
  final String? coverUrl;
  final List<Music> musics;
  const PlaylistState({required this.playlist, required this.musics,this.coverUrl});
  copyWith({Playlist? playlist, List<Music>? musics,String? coverUrl}) {
    return PlaylistState(
        playlist: playlist ?? this.playlist, musics: musics ?? this.musics,coverUrl: coverUrl ?? this.coverUrl);
  }

  @override
  List<Object?> get props => [playlist,musics,coverUrl];
}

class PlaylistInitial extends PlaylistState {
  const PlaylistInitial({required Playlist playlist}) : super(playlist:playlist, musics: const []);
  @override
  List<Object> get props => [];
}
