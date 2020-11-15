formatDuration(Duration d) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (days != 0) {
    tokens.add('${days.toString().padLeft(2,"0")}');
  }
  if (tokens.isNotEmpty || hours != 0) {
    tokens.add('${hours.toString().padLeft(2,"0")}');
  }

  tokens.add('${minutes.toString().padLeft(2,"0")}');
  tokens.add('${seconds.toString().padLeft(2,"0")}');

  return tokens.join(':');
}
