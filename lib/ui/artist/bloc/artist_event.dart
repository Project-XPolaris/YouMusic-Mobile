part of 'artist_bloc.dart';

class ArtistEvent extends Equatable {
  const ArtistEvent();

  @override
  List<Object?> get props => [];
}
class InitEvent extends ArtistEvent {
  const InitEvent();
  @override
  List<Object?> get props => [];
}
class LoadAlbumListEvent extends ArtistEvent {
  const LoadAlbumListEvent();
  @override
  List<Object?> get props => [];
}
class LoadMusicListEvent extends ArtistEvent {
  const LoadMusicListEvent();
  @override
  List<Object?> get props => [];
}
class FollowEvent extends ArtistEvent {
  const FollowEvent();
  @override
  List<Object?> get props => [];
}
class UnFollowEvent extends ArtistEvent {
  const UnFollowEvent();
  @override
  List<Object?> get props => [];
}