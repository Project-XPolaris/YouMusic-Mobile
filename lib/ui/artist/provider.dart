import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';

class ArtistProvider extends ChangeNotifier{
  final int id;
  ArtistProvider(this.id);
  Artist artist;
  List<Music> musicList;
  List<Album> albumList;
  Future<void> loadData() async {
    artist = await ApiClient().fetchArtistById(id.toString());
    notifyListeners();
  }
  Future<void> loadMusic() async {
    if (musicList != null){
      return;
    }
    var response = await ApiClient().fetchMusicList({"pageSize":"5","artist":"${artist.id}"});
    musicList = response.data;
    notifyListeners();
  }
  Future<void> loadAlbum() async {
    if (albumList != null){
      return;
    }
    var response = await ApiClient().fetchAlbum({"pageSize":"5","artist":"${artist.id}"});
    albumList = response.data;
    notifyListeners();
  }
}