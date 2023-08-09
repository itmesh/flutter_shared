enum LoggerLevel {
  info,
  warning,
  error;

  int get level {
    switch (this) {
      case LoggerLevel.info:
        return 0;

      case LoggerLevel.warning:
        return 1;

      case LoggerLevel.error:
        return 2;
    }
  }
}
