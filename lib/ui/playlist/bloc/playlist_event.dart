part of 'playlist_bloc.dart';

class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object?> get props => [];
}

class LoadMusicEvent extends PlaylistEvent {
  final bool force;
  LoadMusicEvent({this.force = false});
  @override
  List<Object?> get props => [force];
}
class LoadMoreMusicEvent extends PlaylistEvent {
  LoadMoreMusicEvent();
  @override
  List<Object?> get props => [];
}