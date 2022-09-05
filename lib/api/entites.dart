import 'package:youmusic_mobile/config.dart';

class Music {
  int? id;
  String? path;
  String? title;
  Album? album;
  double? duration;
  List<Artist> artist = [];

  Music(
      {this.id,
      this.path,
      this.title,
      this.album,
      this.artist = const [],
      this.duration});

  String get displayTitle {
    if (title == null) {
      return path!.split("/").last;
    }
    return title!;
  }

  Music.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    title = json['title'];
    duration = json['duration'].toDouble();
    album = json['album'] != null ? new Album.fromJson(json['album']) : null;
    if (json['artist'] != null) {
      artist = [];
      json['artist'].forEach((v) {
        artist.add(new Artist.fromJson(v));
      });
    }
  }

  getAlbumName(String defaultName) {
    return album?.name ?? defaultName;
  }

  getArtistString(String defaultName) {
    if (artist.length > 0) {
      return artist.map((e) => e.name).join("/");
    }
    return defaultName;
  }

  String? getCoverUrl() {
    return album?.getCoverUrl();
  }
}

class Album {
  int? id;
  String? name;
  String? cover;
  String? blurHash;
  String? color;
  List<Artist> artist = [];
  List<Music> music = [];

  Album(
      {this.id,
      this.name,
      this.cover,
      this.music = const [],
      this.artist = const [],
      this.color,
      this.blurHash});

  Album.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    blurHash = json['blurHash'];
    color = json['color'];
    if (json.containsKey("artist")) {
      artist = List<Artist>.from(
          json['artist'].map((it) => Artist.fromJson(it)).toList());
    }
    if (json.containsKey("music")) {
      music = List<Music>.from(
          json['music'].map((it) => Music.fromJson(it)).toList());
    }
  }

  String? getCoverUrl() {
    if (cover != null) {
      return "${ApplicationConfig().serviceUrl}$cover";
    }
    return null;
  }
  String? get coverUrl{
    if (cover != null) {
      return "${ApplicationConfig().serviceUrl}$cover";
    }
    return null;
  }

  getArtist(String defaultValue) {
    if (artist.length == 0) {
      return defaultValue;
    }
    return artist.map((e) => e.name).join("/");
  }
}

class Artist {
  int? id;
  String? name;
  String? avatar;

  Artist({this.id, this.name});

  Artist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  String? getAvatarUrl() {
    var serviceUrl = ApplicationConfig().serviceUrl;
    if (serviceUrl == null) {
      return null;
    }
    var avatar = this.avatar;
    if (avatar != null) {
      return serviceUrl + avatar;
    }
    return null;
  }

  String get displayName => name ?? "Unknown";
}

class Tag {
  int? id;
  String? name;

  Tag({this.id, this.name});

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  String get displayName => name ?? "Unknown";
}
class Genre {
  int? id;
  String? name;

  Genre({this.id, this.name});

  Genre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  String get displayName => name ?? "Unknown";
}
class Playlist {
  int? id;
  String? name;

  Playlist({this.id, this.name});

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  String get displayName => name ?? "Unknown";
}
class ServiceInfo {
  String? authUrl;
  String? name;

  ServiceInfo.fromJson(Map<String, dynamic> json) {
    authUrl = json['authUrl'];
    name = json['name'];
  }
}

class ListResponseWrap<T> {
  int? count;
  List<T> data = [];

  ListResponseWrap({this.count, this.data = const []});

  ListResponseWrap.fromJson(
      Map<String, dynamic> json, Function(dynamic) converter) {
    count = json['count'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(converter(v));
      });
    }
  }
}
class BaseResponse {
  bool success = false;

  BaseResponse({this.success = false});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    this.success = json['success'] ?? false;
  }
}
