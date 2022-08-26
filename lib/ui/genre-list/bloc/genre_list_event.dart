part of 'genre_list_bloc.dart';

class GenreListEvent extends Equatable {
  const GenreListEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class OnLoadEvent extends GenreListEvent {
  final bool force;
  OnLoadEvent({this.force = false});
  @override
  List<Object?> get props => [force];
}

class OnLoadMoreEvent extends GenreListEvent {
  OnLoadMoreEvent();
  @override
  List<Object?> get props => [];
}

class FilterUpdateEvent extends GenreListEvent {
  final GenreFilter updatedFilter;
  FilterUpdateEvent({required this.updatedFilter});
  @override
  List<Object?> get props => [updatedFilter];
}