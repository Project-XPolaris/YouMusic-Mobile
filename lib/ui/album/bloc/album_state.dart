part of 'album_bloc.dart';

class AlbumState extends Equatable {
  final Album? album;
  final List<Tag> tags;
  final bool isFollow;
  const AlbumState({this.album, required this.tags, required this.isFollow});

  AlbumState copyWith({Album? album, List<Tag>? tags, bool? isFollow}) {
    return AlbumState(
      album: album ?? this.album,
      tags: tags ?? this.tags,
      isFollow: isFollow ?? this.isFollow
    );
  }
  @override
  List<Object?> get props => [album, tags, isFollow];
}

class AlbumInitial extends AlbumState {
  const AlbumInitial() : super(tags: const [], isFollow: false);
  @override
  List<Object> get props => [];
}
