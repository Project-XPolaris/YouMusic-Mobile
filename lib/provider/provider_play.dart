import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/config.dart';
import 'package:youmusic_mobile/player.dart';

enum PlayStatus { Play, Pause }

class PlayProvider extends ChangeNotifier {
  final assetsAudioPlayer = AssetsAudioPlayer.withId("music");
  SharedPreferences prefs;

  PlayProvider() {
    init();
  }

  onCurrentChange(Playing data) {
    if (data.playlist != null) {
      print("save playlist");
      prefs.setStringList(
          "savePlaylist", data.playlist.audios.map((e) => e.metas.id).toList());
    }
  }

  _addToPlaylist(List<Audio> audios,
      {bool append = false, int insert = 0, bool notice = true}) async {
    if (assetsAudioPlayer.playlist == null) {
      assetsAudioPlayer.open(
          Playlist(audios: audios),
          showNotification: notice, autoStart: false
      );
    } else {
      if (append) {
        audios.forEach((element) {
          assetsAudioPlayer.playlist.add(element);
        });
      } else {
        audios.reversed.forEach((audio) {
          assetsAudioPlayer.playlist.insert(insert, audio);
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
      var audio =
          Audio.network("${ApplicationConfig().serviceUrl}/file/audio/${music.id}",
              metas: Metas(
                id: music.id.toString(),
                title: music.title,
                artist: music.getArtistString("Unknown"),
                album: music.getAlbumName("Unknown"),
                extra: {
                  "duration":Duration(seconds: music.duration.toInt())
                },
                image: MetasImage.network(
                    music.getCoverUrl()), //can be MetasImage.network
              ));
      return audio;
    }).toList();
    return audios;
  }

  addAlbumToPlaylist(int albumId) async {
    ListResponseWrap<Music> response = await ApiClient()
        .fetchMusicList({"pageSize": "100", "album": albumId.toString()});
    List<Audio> audios = _createAudioListFromMusicList(response.data);
    _addToPlaylist(audios, append: true);
  }

  playAlbum(int albumId) async {
    ListResponseWrap<Music> response = await ApiClient()
        .fetchMusicList({"pageSize": "100", "album": albumId.toString()});
    _addToPlaylist(_createAudioListFromMusicList(response.data),
        append: false,
        insert: assetsAudioPlayer.current.value?.playlist?.currentIndex ?? 0);
  }

  playMusic(Music music) {
    _addToPlaylist(_createAudioListFromMusicList([music]),
        append: false,
        insert: assetsAudioPlayer.current.value?.playlist?.currentIndex ?? 0);
  }

  addMusicToPlayList(Music music) {
    _addToPlaylist(_createAudioListFromMusicList([music]), append: true);
  }

  removeFromPlayList(int index, String id) {
    assetsAudioPlayer.playlist.removeAtIndex(index);
    prefs.setStringList(
        "savePlaylist",
        assetsAudioPlayer.playlist.audios
            .where((element) => element.metas.id != id)
            .map((e) => e.metas.id)
            .toList());
  }
}
