part of 'tag_bloc.dart';

class TagState extends Equatable {
  final Tag? tag;
  final List<Album> albumList;
  final AlbumFilter albumFilter;
  final List<Music> musicList;
  final MusicFilter musicFilter;
  final int idx;
  final bool isFollow;

  String get displayTagName => tag?.name ?? "Unknown";

  const TagState(
      {this.tag,
      required this.albumList,
      required this.musicList,
      required this.idx,
      required this.albumFilter,
      required this.isFollow,
      required this.musicFilter});

  copyWith(
      {List<Album>? albumList,
      List<Music>? musicList,
      int? idx,
      Tag? tag,
      bool? isFollow,
      AlbumFilter? albumFilter,
      MusicFilter? musicFilter}) {
    return TagState(
        albumList: albumList ?? this.albumList,
        musicList: musicList ?? this.musicList,
        idx: idx ?? this.idx,
        tag: tag ?? this.tag,
        isFollow: isFollow ?? this.isFollow,
        albumFilter: albumFilter ?? this.albumFilter,
        musicFilter: musicFilter ?? this.musicFilter);
  }

  @override
  List<Object?> get props =>
      [albumList, musicList, idx, tag, albumFilter, musicFilter,isFollow];
}

class TagInitial extends TagState {
  TagInitial()
      : super(
            albumList: const [],
            musicList: const [],
            idx: 0,
            isFollow: false,
            albumFilter: AlbumFilter(order: "id desc"),
            musicFilter: MusicFilter(order: "id desc"));

  @override
  List<Object> get props => [];
}
