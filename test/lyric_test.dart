// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:youmusic_mobile/main.dart';
import 'package:youmusic_mobile/utils/lyric.dart';

String rawLrc = """
[ar:oasis]
[ti:champagne supernova]
[length:07:27.04]
[by:angie]
[re:www.megalobiz.com/lrc/maker]
[ve:v1.2.3]
[00:32.10]How many special people change?
[00:35.08]How many lives are living strange?
[00:38.60]Where were you while we were getting high?
[00:45.35]Slowly walking down the hall
[00:48.35]Faster than a cannonball
[00:51.60]Where were you while we were getting high?
[00:56.35]Someday you will find me
[00:59.35]Caught beneath the landslide
[01:03.60]In a champagne supernova in the sky
[01:08.85]Someday you will find me
[01:11.85]Caught beneath the landslide
[01:16.35]In a champagne supernova
[01:20.10]A champagne supernova in the sky
[01:35.85]Wake up the dawn and ask her why
[01:39.09]A dreamer dreams she never dies
[01:42.60]Wipe that tear away now from your eye
[01:49.07]Slowly walking down the hall
[01:52.09]Faster than a cannonball
[01:55.07]Where were you while we were getting high?
[01:59.85]Someday you will find me
[02:03.10]Caught beneath the landslide
[02:07.10]In a champagne supernova in the sky
[02:12.35]Someday you will find me
[02:15.85]Caught beneath the landslide
[02:19.85]In a champagne supernova
[02:23.57]A champagne supernova
[02:26.59]'Cause people believe
[02:29.57]That they're gonna get away for the summer
[02:39.35]But you and I, we live and die
[02:43.10]The world's still spinning 'round, we don't know why
[02:48.85]Why, why, why, why?
[03:18.35]How many special people change?
[03:21.35]How many lives are living strange?
[03:24.35]Where were you while we were getting high?
[03:31.10]Slowly walking down the hall
[03:33.83]Faster than a cannonball
[03:37.11]Where were you while we were getting high?
[03:41.57]Someday you will find me
[03:45.06]Caught beneath the landslide
[03:49.09]In a champagne supernova in the sky
[03:54.82]Someday you will find me
[03:57.85]Caught beneath the landslide
[04:02.10]In a champagne supernova
[04:05.85]A champagne supernova
[04:08.85]'Cause people believe
[04:11.60]That they're gonna get away for the summer
[04:21.09]But you and I, we live and die
[04:24.81]The world's still spinning 'round, we don't know why
[04:31.11]Why, why, why, why?
[05:57.60]How many special people change?
[06:00.60]How many lives are living strange?
[06:03.85]Where were you while we were getting high?
[06:09.11]We were getting high
[06:11.60]We were getting high
[06:15.07]We were getting high
[06:18.60]We were getting high
[06:21.60]We were getting high
[06:24.85]We were getting high
[06:28.10]We were getting high
[06:31.35]We were getting high
[06:34.35]We were getting high
[06:37.85]We were getting high
""";

void main() {
  test("lyric", () {
    RegExp exp = RegExp(r"^\[([\d:.]*)\]{1}");
    for (var line in rawLrc.split("\n")) {
      Iterable<Match> matches = exp.allMatches(line);
      if (matches == null || matches.length < 1) {

        continue;
      }
      String timeString = matches.elementAt(0).group(1);

      RegExp timeRegex = RegExp(r"(\d+):(\d+)\.(\d+)");
      var timePartResult = timeRegex.allMatches(timeString).elementAt(0);
      if (timePartResult != null){
        print("${timePartResult.group(1)} ${timePartResult.group(2)} ${timePartResult.group(3)}");
      }


    }
  });
  test("lyricManager",() {
    LyricsManager manager = LyricsManager.fromText(rawLrc);
    print(manager);
  });
}
