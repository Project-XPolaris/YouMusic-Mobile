part of 'genre_bloc.dart';

class GenreEvent extends Equatable {
  const GenreEvent();
  @override
  List<Object?> get props => [];
}

class LoadAlbumEvent extends GenreEvent {
  final bool force;
  LoadAlbumEvent({this.force = false});
  @override
  List<Object?> get props => [force];
}
class LoadMoreAlbumEvent extends GenreEvent {
  LoadMoreAlbumEvent();
  @override
  List<Object?> get props => [];
}
class LoadMoreMusicEvent extends GenreEvent {
  LoadMoreMusicEvent();
  @override
  List<Object?> get props => [];
}
class LoadMusicEvent extends GenreEvent {
  final bool force;
  LoadMusicEvent({this.force = false});
  @override
  List<Object?> get props => [force];
}
class UpdateAlbumFilterEvent extends GenreEvent {
  final AlbumFilter updatedFilter;
  UpdateAlbumFilterEvent({required this.updatedFilter});
  @override
  List<Object?> get props => [updatedFilter];
}
class UpdateMusicFilterEvent extends GenreEvent {
  final MusicFilter updatedFilter;
  UpdateMusicFilterEvent({required this.updatedFilter});
  @override
  List<Object?> get props => [updatedFilter];
}
class TabIndexChangeEvent extends GenreEvent {
  final int index;
  TabIndexChangeEvent({required this.index});
  @override
  List<Object?> get props => [index];
}