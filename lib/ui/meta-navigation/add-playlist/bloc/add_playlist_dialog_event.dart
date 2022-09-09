part of 'add_playlist_dialog_bloc.dart';

class AddPlaylistDialogEvent extends Equatable {
  const AddPlaylistDialogEvent();

  @override
  List<Object?> get props => [];
}

class LoadDataEvent extends AddPlaylistDialogEvent {

}
class CreateAndAddMusic extends AddPlaylistDialogEvent {
  final int musicId ;
  final String name;
  CreateAndAddMusic({required this.musicId,required this.name});
  @override
  List<Object?> get props => [musicId,name];
}
class InputNameChanged extends AddPlaylistDialogEvent {
  final String name;
  InputNameChanged({required this.name});
  @override
  List<Object?> get props => [name];
}