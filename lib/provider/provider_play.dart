import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/config.dart';
import 'package:youmusic_mobile/utils/lyric.dart';

enum PlayStatus { Play, Pause }

class PlayProvider extends ChangeNotifier {
  final assetsAudioPlayer = AssetsAudioPlayer.withId("music");
  LyricsManager? lyricsManager;
  String lyricId = "0";
  SharedPreferences? prefs;
  bool firstLoad = true;

  PlayProvider() {
    init();
  }

  loadLyrics(String id) async {
    lyricsManager = null;
    lyricId = id;
    notifyListeners();
    String rawLyrics = await ApiClient().fetchLyrics(id);
    lyricsManager = new LyricsManager.fromText(rawLyrics);
    notifyListeners();
  }

  onCurrentChange(Playing data) {
    saveHistory();
  }

  _addToPlaylist(List<Audio> audios,
      {bool append = false, int insert = 0, bool notice = true}) async {
    var playlist = assetsAudioPlayer.playlist;
    if (playlist == null) {
      assetsAudioPlayer.open(Playlist(audios: audios),
          showNotification: notice, autoStart: false);
    } else {
      if (append) {
        audios.forEach((element) {
          playlist.add(element);
        });
      } else {
        audios.reversed.forEach((audio) {
          playlist.insert(insert, audio);
        });
      }
    }
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    // List<String> savePlaylist = prefs.getStringList("savePlaylist") ?? [];
    // int currentIndex = prefs.getInt("currentIndex") ?? 0;
    // if (savePlaylist.length == 0) {
    //   return;
    // }
    // var musicListResponse = await ApiClient().fetchMusicList({
    //   "ids": savePlaylist.join(","),
    //   "pageSize": savePlaylist.length.toString()
    // });
    // _addToPlaylist(_createAudioListFromMusicList(musicListResponse.data),
    //     append: true, notice: true);
    // if (currentIndex != 0) {
    //   assetsAudioPlayer.playlistPlayAtIndex(currentIndex);
    // }
  }

  _createAudioListFromMusicList(List<Music> musicList) {
    var audios = musicList.map((music) {
      var coverUrl = music.getCoverUrl();
      var audio = Audio.network(
          "${ApplicationConfig().serviceUrl}/file/audio/${music.id}",
          metas: Metas(
            id: music.id.toString(),
            title: music.title,
            artist: music.getArtistString("Unknown"),
            album: music.getAlbumName("Unknown"),
            extra: {
              "duration": Duration(seconds: (music.duration ?? 0).toInt())
            },
            image: coverUrl != null
                ? MetasImage.network(coverUrl)
                : null, //can be MetasImage.network
          ),
          cached: false);
      return audio;
    }).toList();
    return audios;
  }

  addAlbumToPlaylist(int albumId) async {
    ListResponseWrap<Music> response = await ApiClient()
        .fetchMusicList({"pageSize": "100", "album": albumId.toString()});
    List<Audio> audios = _createAudioListFromMusicList(response.data);
    var playlist = assetsAudioPlayer.playlist;
    if (playlist == null) {
      assetsAudioPlayer.open(Playlist(audios: audios),
          showNotification: true, autoStart: false);
      return;
    }
    int playIndex = assetsAudioPlayer.current.value?.index ?? 0;
    Audio currentPlayAudio = playlist.audios[playIndex];
    int existIndex = audios
        .indexWhere((element) => element.metas.id == currentPlayAudio.metas.id);
    if (existIndex == -1) {
      audios.reversed.forEach((audio) {
        playlist.insert(playIndex + 1, audio);
      });
    }
    saveHistory();
  }

  playAlbum(int albumId) async {
    ListResponseWrap<Music> response = await ApiClient()
        .fetchMusicList({"pageSize": "100", "album": albumId.toString()});
    List<Audio> audios = _createAudioListFromMusicList(response.data);
    assetsAudioPlayer.open(Playlist(audios: audios),
        showNotification: true, autoStart: true);
    saveHistory();
  }

  playMusic(Music music, {autoPlay: false}) {
    int index = assetsAudioPlayer.current.value?.playlist.currentIndex ?? 0;
    var playlist = assetsAudioPlayer.playlist;
    if (playlist != null) {
      playlist.audios
          .removeWhere((element) => element.metas.id == music.id.toString());
    }
    _addToPlaylist(_createAudioListFromMusicList([music]),
        append: false, insert: index + 1);
    if (playlist != null && playlist.audios.length > 1 && autoPlay) {
      assetsAudioPlayer.playlistPlayAtIndex(index + 1);
      assetsAudioPlayer.play();
    }
    saveHistory();
  }

  addMusicToPlayList(Music music) {
    int playIndex = assetsAudioPlayer.current.value?.index ?? 0;
    var playlist = assetsAudioPlayer.playlist;
    if (playlist != null) {
      playlist.audios
          .removeWhere((element) => element.metas.id == music.id.toString());
    }

    _addToPlaylist(_createAudioListFromMusicList([music]),
        append: false, insert: playIndex + 1);
  }

  removeFromPlayList(int index, String id) {
    var playlist = assetsAudioPlayer.playlist;
    var prefs = this.prefs;
    if (playlist == null || prefs == null) {
      return;
    }
    playlist.removeAtIndex(index);
    prefs.setStringList(
        "savePlaylist",
        playlist.audios
            .where((element) => element.metas.id != id)
            .map((e) => e.metas.id!)
            .toList());
  }

  saveHistory() async {
    var playlist = assetsAudioPlayer.playlist;
    if (playlist == null) {
      return;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var ids = playlist.audios.map((e) => e.metas.id!).toList();
    sharedPreferences.setStringList(
        "${ApplicationConfig().username}_savePlayList", ids);
    var index = assetsAudioPlayer.current.value?.audio.audio.metas.id ?? "0";
    sharedPreferences.setString(
        "${ApplicationConfig().username}_playId", index);
  }

  loadHistory() async {
    if (!firstLoad) {
      return;
    }
    firstLoad = false;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var ids = sharedPreferences
        .getStringList("${ApplicationConfig().username}_savePlayList");
    if (ids == null) {
      return;
    }
    var response = await ApiClient().fetchMusicList({"ids": ids.join(",")});
    List<Audio> audios = _createAudioListFromMusicList(response.data);
    _addToPlaylist(audios);
    // String? playId = sharedPreferences.getString("${ApplicationConfig().username}_playId");
    // var index = audios.indexWhere((element) => element.metas.id == playId);
    // if (index != -1) {
    //   assetsAudioPlayer.playlistPlayAtIndex(index);
    // }
  }
}
