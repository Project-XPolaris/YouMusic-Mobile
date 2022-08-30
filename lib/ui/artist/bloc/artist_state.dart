part of 'artist_bloc.dart';

class ArtistState extends Equatable {
  final Artist? artist;
  final List<Music> musicList;
  final List<Album> albumList;
  final bool isFollow;
  const ArtistState({this.artist,required this.musicList,required this.albumList,this.isFollow = false});

  @override
  List<Object?> get props => [artist,musicList,albumList,isFollow];

  copyWith({Artist? artist,List<Music>? musicList,List<Album>? albumList,bool? isFollow}) {
    return ArtistState(
      artist: artist ?? this.artist,
      musicList: musicList ?? this.musicList,
      albumList: albumList ?? this.albumList,
      isFollow: isFollow ?? this.isFollow
    );
  }
}

class ArtistInitial extends ArtistState {
  const ArtistInitial() : super(musicList: const [],albumList: const []);
}
