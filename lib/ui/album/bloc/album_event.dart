part of 'album_bloc.dart';

class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object?> get props => [];
}

class AlbumInitialEvent extends AlbumEvent {

}
class FollowEvent extends AlbumEvent {

}
class UnFollowEvent extends AlbumEvent {

}