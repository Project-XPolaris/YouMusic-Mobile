import 'package:youmusic_mobile/config.dart';

class Music {
  int id;
  String path;
  String title;
  Album album;
  List<Artist> artist;

  Music({this.id, this.path, this.title, this.album, this.artist});

  Music.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    title = json['title'];
    album = json['album'] != null ? new Album.fromJson(json['album']) : null;
    if (json['artist'] != null) {
      artist = new List<Artist>();
      json['artist'].forEach((v) {
        artist.add(new Artist.fromJson(v));
      });
    }
  }
  getAlbumName(String defaultName){
    if (album != null){
      return album.name;
    }
    return defaultName;
  }

  getArtistString(String defaultName){
    if (artist != null && artist.length > 0){
      return artist.map((e) => e.name).join("/");
    }
    return defaultName;
  }

  getCoverUrl() {
    if (album != null) {
      return album.getCoverUrl();
    }
  }
}

class Album {
  int id;
  String name;
  String cover;
  List<Artist> artist;
  Album({this.id, this.name, this.cover});

  Album.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    if (json.containsKey("artist")){
       artist = List<Artist>.from(json['artist'].map((it) => Artist.fromJson(it)).toList());
    }
  }
  getCoverUrl() {
    return "${ApplicationConfig.apiUrl}$cover";
  }
}

class Artist {
  int id;
  String name;

  Artist({this.id, this.name});

  Artist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class ListResponseWrap<T> {
  int count;
  List<T> data;

  ListResponseWrap({this.count, this.data});

  ListResponseWrap.fromJson(Map<String, dynamic> json,Function(dynamic) converter) {
    count = json['count'];
    if (json['data'] != null) {
      data = new List<T>();
      json['data'].forEach((v) {
        data.add(converter(v));
      });
    }
  }
}