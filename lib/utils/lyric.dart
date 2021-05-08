class LyricsLine {
  int milliseconds;
  String text;

  LyricsLine({this.milliseconds, this.text});
}

class LyricsManager {
  List<LyricsLine> lines = [];

  LyricsManager.fromText(String text) {
    RegExp exp = RegExp(r"^\[([\d:.]*)\]{1}");
    for (var line in text.split("\n")) {
      Iterable<Match> matches = exp.allMatches(line);
      if (matches == null || matches.length < 1) {
        continue;
      }
      String timeString = matches.elementAt(0).group(1);
      RegExp timeRegex = RegExp(r"(\d+):(\d+)\.(\d+)");
      var timePartResult = timeRegex.allMatches(timeString).elementAt(0);
      if (timePartResult == null) {
        continue;
      }
      Duration dur = Duration(
          minutes: int.parse(timePartResult.group(1)),
          seconds: int.parse(timePartResult.group(2)),
          milliseconds: int.parse(timePartResult.group(3)));
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
      if (lines[i].milliseconds <= time && lines[i + i].milliseconds > time ) {
        return i;
      }
    }
  }
}
