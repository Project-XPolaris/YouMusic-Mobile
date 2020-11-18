import 'package:assets_audio_player/assets_audio_player.dart';

class PlayerService {
  static final PlayerService _singleton = PlayerService._internal();
  final assetsAudioPlayer = AssetsAudioPlayer();

  factory PlayerService() {
    return _singleton;
  }
  PlayerService._internal();
}
