import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

getLoopIcon(LoopMode? mode) {
  if(mode == null){
    return Icons.loop;
  }
  if(mode == LoopMode.playlist){
    return Icons.loop;
  }
  if (mode == LoopMode.single){
    return Icons.repeat_one_outlined;
  }
  if (mode == LoopMode.none){
    return Icons.repeat;
  }
}