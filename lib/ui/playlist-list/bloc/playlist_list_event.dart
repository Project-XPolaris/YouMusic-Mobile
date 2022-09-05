part of 'playlist_list_bloc.dart';

class PlaylistListEvent extends Equatable {
  const PlaylistListEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvent extends PlaylistListEvent {
  final bool force;
  LoadEvent({this.force = false});
  @override
  List<Object?> get props => [force];
}
class LoadMoreEvent extends PlaylistListEvent {
  LoadMoreEvent();
  @override
  List<Object?> get props => [];
}