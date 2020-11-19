import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/client.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/config.dart';
import 'package:youmusic_mobile/player.dart';

enum PlayStatus { Play, Pause }

class PlayProvider extends ChangeNotifier {
  final assetsAudioPlayer = AssetsAudioPlayer.withId("music");

  loadMusic(Music music) {
    var audio =
        Audio.network("${ApplicationConfig.apiUrl}/file/audio/${music.id}",
            metas: Metas(
              title: music.title,
              artist: music.getArtistString("unknown"),
              album: music.getAlbumName("Unknown"),
              image: MetasImage.network(
                  music.getCoverUrl()), //can be MetasImage.network
            ));
    assetsAudioPlayer.open(
      Playlist(audios: [
        audio,
      ]),
      loopMode: LoopMode.playlist,
      showNotification: true,
    );
  }

  loadAlbumPlaylist(List<Music> musicList, Album album) {
    var audios = musicList.map((music) {
      var audio =
          Audio.network("${ApplicationConfig.apiUrl}/file/audio/${music.id}",
              metas: Metas(
                title: music.title,
                artist: album.getArtist("Unknown"),
                album: album.name,
                image: MetasImage.network(
                    album.getCoverUrl()), //can be MetasImage.network
              ));
      return audio;
    }).toList();
    playPlaylist(audios);
  }

  playPlaylist(List<Audio> audios, {bool append = false}) {
    if (append) {
      audios.forEach((element) {
        assetsAudioPlayer.playlist.add(element);
      });
    } else {
      assetsAudioPlayer.open(Playlist(audios: audios),
          showNotification: true, loopMode: LoopMode.playlist);
    }
  }

  createAudioListFromMusicList(List<Music> musicList) {
    var audios = musicList.map((music) {
      var audio =
          Audio.network("${ApplicationConfig.apiUrl}/file/audio/${music.id}",
              metas: Metas(
                title: music.title,
                artist: music.getArtistString("Unknown"),
                album: music.getAlbumName("Unknown"),
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
    playPlaylist(createAudioListFromMusicList(response.data), append: true);
  }
}
