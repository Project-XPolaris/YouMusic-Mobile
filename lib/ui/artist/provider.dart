import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';

class ArtistProvider extends ChangeNotifier{
  final int id;
  ArtistProvider(this.id);
  Artist artist;
  MusicLoader musicLoader = new MusicLoader();
  AlbumLoader albumLoader = new AlbumLoader();
  Future<void> loadData() async {
    if (artist != null){
      return;
    }
    artist = await ApiClient().fetchArtistById(id.toString());
    await loadMusic();
    await loadAlbum();
    notifyListeners();
  }
  Future<void> loadMusic() async {
    if (artist == null){
      return;
    }
    await musicLoader.loadData(extraFilter: {"artist":artist.id.toString()});
  }

  Future<void> loadAlbum() async {
    if (artist == null){
      return;
    }
    await albumLoader.loadData(extraFilter: {"artist":artist.id.toString()});
  }
}