import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:youmusic_mobile/provider/provider_play.dart';

class PlaySlider extends StatefulWidget {
  @override
  _PlaySliderState createState() => _PlaySliderState();

}

class _PlaySliderState extends State<PlaySlider> {
  double currentValue = -1;
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayProvider>(builder: (context, provider, child) {
      return Container(
        child: StreamBuilder(
            stream: provider.assetsAudioPlayer.currentPosition,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData){

              }
              Duration currentPlayPosition = asyncSnapshot.data ?? Duration();
              Duration totalDuration = provider
                  .assetsAudioPlayer.current.valueWrapper.value.audio.audio.metas.extra["duration"];
              return SliderTheme(
                data: SliderThemeData(
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                  trackShape: RoundedRectSliderTrackShape(),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                ),
                child: Slider(
                  value: currentValue < 0?currentPlayPosition.inSeconds.toDouble():currentValue,
                  min: 0,
                  max: totalDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      currentValue = value;
                    });
                  },
                  onChangeEnd: (value){
                    provider.assetsAudioPlayer.seek(Duration(seconds: value.toInt()));
                    setState(() {
                      currentValue = -1;
                    });
                  },
                  inactiveColor: Colors.pink[900],
                  activeColor: Colors.pink,
                ),
              );
            }),
      );
    });
  }
}
