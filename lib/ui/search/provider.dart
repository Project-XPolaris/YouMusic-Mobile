import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/loader/album_loader.dart';
import 'package:youmusic_mobile/api/loader/artist_loader.dart';
import 'package:youmusic_mobile/api/loader/music_loader.dart';
import 'package:youmusic_mobile/api/loader/playlist_loader.dart';
import 'package:youmusic_mobile/api/loader/tag_loader.dart';

class SearchProvider extends ChangeNotifier {
  MusicLoader musicLoader = MusicLoader();
  AlbumLoader albumLoader = AlbumLoader();
  ArtistLoader artistLoader = ArtistLoader();
  TagLoader tagLoader = TagLoader();
  PlaylistLoader playlistLoader = PlaylistLoader();
  search(String key) async {
    if (await musicLoader.loadData(
        force: true,
        extraFilter: {"page": "1", "pageSize": "5", "search": key})) {
      notifyListeners();
    }
    if (await albumLoader.loadData(
        force: true,
        extraFilter: {"page": "1", "pageSize": "5", "search": key})) {
      notifyListeners();
    }
    if (await artistLoader.loadData(
        force: true,
        extraFilter: {"page": "1", "pageSize": "5", "search": key})) {
      notifyListeners();
    }
    if (await tagLoader.loadData(
        force: true,
        extraFilter: {"page": "1", "pageSize": "5", "search": key})) {
      notifyListeners();
    }
    if (await playlistLoader.loadData(
        force: true,
        extraFilter: {"page": "1", "pageSize": "5", "name": key})) {
      notifyListeners();
    }
  }
}
