enum LogLevel {
  trace,
  debug,
  info,
  warn,
  error;

  int code() => switch (this) {
    LogLevel.trace => 0,
    LogLevel.debug => 10,
    LogLevel.info => 20,
    LogLevel.warn => 30,
    LogLevel.error => 40,
  };

  List<LogLevel> contains() {
    final res = <LogLevel>[];
    for (final level in LogLevel.values) {
      if (code() >= level.code()) {
        res.add(level);
      }
    }

    return res;
  }
}
