import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:youmusic_mobile/api/entites.dart';
import 'package:youmusic_mobile/config.dart';
import 'package:youmusic_mobile/player.dart';

enum PlayStatus { Play, Pause }

class PlayProvider extends ChangeNotifier {
  Music currentMusic;
  PlayStatus playStatus = PlayStatus.Pause;
  PlayerService playerService = PlayerService();

  PlayProvider() {
    AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
      print("====================");
      return true; //true : handled, does not notify others listeners
    });
  }

  loadMusic(Music music) {
    currentMusic = music;
    var audio =
        Audio.network("${ApplicationConfig.apiUrl}/file/audio/${music.id}",
            metas: Metas(
              title: music.title,
              artist: music.getArtistString("unknown"),
              album: music.getAlbumName("Unknown"),
              image: MetasImage.network(
                  music.getCoverUrl()), //can be MetasImage.network
            ));
    playerService.assetsAudioPlayer.open(
        Playlist(audios: [
          audio,
        ]),
        loopMode: LoopMode.playlist,
        showNotification: true,
        notificationSettings:
            NotificationSettings(customPlayPauseAction: customPlayPauseAction));
    playStatus = PlayStatus.Play;
    notifyListeners();
  }

  customPlayPauseAction(AssetsAudioPlayer player) {
    if (playStatus == PlayStatus.Pause) {
      resumePlay();
    } else if (playStatus == PlayStatus.Play) {
      pausePlay();
    }
    notifyListeners();
  }

  loadAlbumPlaylist(List<Music> musicList, Album album) {
    currentMusic = musicList.first;
    currentMusic.album = album;
    currentMusic.artist = album.artist;
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

    playerService.assetsAudioPlayer.open(Playlist(audios: audios),
        loopMode: LoopMode.playlist,
        showNotification: true,
        notificationSettings:
            NotificationSettings(customPlayPauseAction: customPlayPauseAction));
    playStatus = PlayStatus.Play;
    notifyListeners();
  }

  setCurrentPlay(Music music) {
    currentMusic = music;
    notifyListeners();
  }

  resumePlay() {
    playerService.assetsAudioPlayer.play();
    playStatus = PlayStatus.Play;
    notifyListeners();
  }

  pausePlay() {
    playerService.assetsAudioPlayer.pause();
    print("paused");
    playStatus = PlayStatus.Pause;
    notifyListeners();
  }
}
