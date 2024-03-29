part of 'genre_bloc.dart';

class GenreState extends Equatable {
  final List<Music> musicList;
  final List<Album> albumList;
  final MusicFilter musicFilter;
  final AlbumFilter albumFilter;
  final int index;
  final bool isFollow;

  const GenreState(
      {required this.musicList,
      required this.albumList,
      required this.musicFilter,
      required this.albumFilter,
      required this.isFollow,
      required this.index});

  GenreState copyWith(
      {List<Music>? musicList,
      List<Album>? albumList,
      MusicFilter? musicFilter,
      AlbumFilter? albumFilter,
      bool? isFollow,
      int? index}) {
    return GenreState(
        musicList: musicList ?? this.musicList,
        albumList: albumList ?? this.albumList,
        musicFilter: musicFilter ?? this.musicFilter,
        albumFilter: albumFilter ?? this.albumFilter,
        isFollow: isFollow ?? this.isFollow,
        index: index ?? this.index);
  }

  @override
  List<Object> get props {
    return [musicList, albumList, albumFilter, musicFilter, index, isFollow];
  }
}

class GenreInitial extends GenreState {
  GenreInitial()
      : super(
            musicList: [],
            albumList: [],
            musicFilter: MusicFilter(order: 'id desc'),
            albumFilter: AlbumFilter(order: 'id desc'),
            isFollow: false,
            index: 0);
}
