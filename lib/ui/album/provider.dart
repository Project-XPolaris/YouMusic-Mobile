import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';

class AlbumProvider extends ChangeNotifier{
  final int id;
  AlbumProvider(this.id);
  Album album;
  Future<void> loadData() async {
    album = await ApiClient().fetchAlbumById(id.toString());
    return;
  }
}