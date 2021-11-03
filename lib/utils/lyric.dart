class LyricsLine {
  int milliseconds;
  String text;

  LyricsLine({required this.milliseconds, required this.text});
}

class LyricsManager {
  List<LyricsLine> lines = [];

  LyricsManager.fromText(String text) {
    RegExp exp = RegExp(r"^\[([\d:.]*)\]{1}");
    for (var line in text.split("\n")) {
      Iterable<Match> matches = exp.allMatches(line);
      if (matches.length < 1) {
        continue;
      }
      String? timeString = matches.elementAt(0).group(1);
      if (timeString == null) {
        continue;
      }
      RegExp timeRegex = RegExp(r"(\d+):(\d+)\.(\d+)");
      var timePartResult = timeRegex.allMatches(timeString).elementAt(0);
      var minute = timePartResult.group(1);
      var second = timePartResult.group(2);
      var milliseconds = timePartResult.group(3);
      if (minute == null || second == null || milliseconds == null) {
        continue;
      }
      Duration dur = Duration(
          minutes: int.parse(minute),
          seconds: int.parse(second),
          milliseconds: int.parse(milliseconds));
      String lyricText = line.replaceAll("[$timeString]", "").trim();
      lines.add(
          new LyricsLine(milliseconds: dur.inMilliseconds, text: lyricText));
    }
  }

  getIndex(int time) {
    if (lines.isEmpty) {
      return -1;
    }
    if (lines.first.milliseconds > time) {
      return 0;
    }
    if (lines.last.milliseconds < time) {
      return lines.length - 1;
    }
    for (int i = 0; i < lines.length - 1; i++) {
      if (lines[i].milliseconds > time) {
        return i - 1;
      }
    }
  }
}
