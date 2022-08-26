part of 'genre_bloc.dart';

class GenreState extends Equatable {
  final List<Music> musicList;
  final List<Album> albumList;
  final MusicFilter musicFilter;
  final AlbumFilter albumFilter;
  final int index;

  const GenreState(
      {required this.musicList,
      required this.albumList,
      required this.musicFilter,
      required this.albumFilter,
      required this.index});

  GenreState copyWith(
      {List<Music>? musicList,
      List<Album>? albumList,
      MusicFilter? musicFilter,
      AlbumFilter? albumFilter,
      int? index}) {
    return GenreState(
        musicList: musicList ?? this.musicList,
        albumList: albumList ?? this.albumList,
        musicFilter: musicFilter ?? this.musicFilter,
        albumFilter: albumFilter ?? this.albumFilter,
        index: index ?? this.index);
  }

  @override
  List<Object> get props {
    return [musicList, albumList,albumFilter,musicFilter, index];
  }
}

class GenreInitial extends GenreState {
  GenreInitial()
      : super(
            musicList: [],
            albumList: [],
            musicFilter: MusicFilter(order: 'id desc'),
            albumFilter: AlbumFilter(order: 'id desc'),
            index: 0);
}
