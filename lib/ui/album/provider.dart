import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';

class AlbumProvider extends ChangeNotifier{
  final int id;
  AlbumProvider(this.id);
  Album? album;
  bool first = true;
  Future<void> loadData() async {
    if (!first) {
      return;
    }
    first = false;
    album = await ApiClient().fetchAlbumById(id.toString());
    notifyListeners();
    return;
  }
}