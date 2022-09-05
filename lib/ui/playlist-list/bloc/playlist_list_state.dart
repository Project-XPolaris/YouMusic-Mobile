part of 'playlist_list_bloc.dart';

class PlaylistListState extends Equatable {
  final List<Playlist> list;
  final PlaylistFilter filter;
  const PlaylistListState({required this.list, required this.filter});
  List<Object> get props => [list];
  copyWith({List<Playlist>? list, PlaylistFilter? filter}) {
    return PlaylistListState(list: list ?? this.list, filter: filter ?? this.filter);
  }
}

class PlaylistListInitial extends PlaylistListState {
  PlaylistListInitial() : super(list: const [],filter: PlaylistFilter(order: "id desc"));
  @override
  List<Object> get props => [];
}