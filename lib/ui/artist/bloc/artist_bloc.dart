
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youmusic_mobile/event.dart';
import 'package:youmusic_mobile/event/artist.dart';

import '../../../api/client.dart';
import '../../../api/entites.dart';
import '../../../api/loader/album_loader.dart';
import '../../../api/loader/music_loader.dart';

part 'artist_event.dart';
part 'artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final int artistId;
  AlbumLoader albumLoader = AlbumLoader();
  MusicLoader musicLoader = MusicLoader();
  final Map<String,String> extraFilter = {};
  ArtistBloc({required this.artistId}) : super(ArtistInitial()) {
    extraFilter["artist"] = artistId.toString();
    on<InitEvent>((event, emit) async {
      await loadArtist(event, emit);
      await loadMusic(event, emit);
      await loadAlbum(event, emit);
      await checkIsFollow(event, emit);
    });
    on<FollowEvent>((event,emit)async{
      BaseResponse result = await ApiClient().followArtist(artistId);
      if (result.success){
        await checkIsFollow(event, emit);
      }
    });
    on<UnFollowEvent>((event,emit)async{
      BaseResponse result = await ApiClient().unFollowArtist(artistId);
      if (result.success){
        await checkIsFollow(event, emit);
      }
      EventBusManager.instance.eventBus.fire(ArtistFollowChangeEvent(artistId: artistId, isFollow: false));
    });
  }
  loadArtist(event, emit) async {
    var artist = await ApiClient().fetchArtistById(artistId.toString());
    emit(state.copyWith(artist: artist));
  }
  loadMusic(event, emit) async {
    await musicLoader.loadData(extraFilter: extraFilter);
    emit(state.copyWith(musicList: musicLoader.list));
  }
  loadAlbum(event, emit) async {
    await albumLoader.loadData(extraFilter: extraFilter);
    emit(state.copyWith(albumList: albumLoader.list));
  }

  checkIsFollow(event,emit) async {
    var response = await ApiClient().fetchArtist({"id": artistId.toString(),"follow":"1"});
    bool isFollow = response.data.length > 0;
    emit(state.copyWith(isFollow: isFollow));
  }

}
