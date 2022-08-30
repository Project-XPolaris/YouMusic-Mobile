part of 'tag_bloc.dart';

class TagEvent extends Equatable {
  const TagEvent();

  @override
  List<Object?> get props => [];
}

class TabChangeEvent extends TagEvent {
  final int idx;

  TabChangeEvent(this.idx);

  @override
  List<Object?> get props => [idx];
}

class InitEvent extends TagEvent {
  InitEvent();
  @override
  List<Object?> get props => [];
}
class AlbumFilterUpdatedEvent extends TagEvent {
  final AlbumFilter albumFilter;
  AlbumFilterUpdatedEvent(this.albumFilter);
  @override
  List<Object?> get props => [albumFilter];
}
class MusicFilterUpdatedEvent extends TagEvent {
  final MusicFilter musicFilter;
  MusicFilterUpdatedEvent(this.musicFilter);
  @override
  List<Object?> get props => [musicFilter];
}
class LoadMoreAlbumEvent extends TagEvent {
  LoadMoreAlbumEvent();
  @override
  List<Object?> get props => [];
}
class LoadMoreMusicEvent extends TagEvent {
  LoadMoreMusicEvent();
  @override
  List<Object?> get props => [];
}
class FollowEvent extends TagEvent {
  FollowEvent();
  @override
  List<Object?> get props => [];
}
class UnFollowEvent extends TagEvent {
  UnFollowEvent();
  @override
  List<Object?> get props => [];
}