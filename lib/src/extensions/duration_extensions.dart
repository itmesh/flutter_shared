extension DurationExtensions<T extends Duration> on T {
  String get readable {
    final String hours = inHours.toString().padLeft(2, '0');
    final String minutes = (inMinutes % 60).toString().padLeft(2, '0');
    final String seconds = (inSeconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  String get readableInMinutes {
    final String minutes = (inMinutes).toString().padLeft(2, '0');
    final String seconds = (inSeconds % 60).toString().padLeft(2, '0');

    if (seconds == '00') {
      return minutes;
    }

    return '$minutes:$seconds';
  }
}
