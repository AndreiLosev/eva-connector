enum Process {
  value,
  status,
  action;

  static Process fromString(String str) {
    return switch (str) {
      'value' => Process.value,
      'status' => Process.status,
      'action' => Process.action,
      _ => throw Exception("invalid Process: $str"),
    };
  }
}

enum OutputProperty {
  status,
  value,
  time,
  timeSec,
  timeMillis,
  timeMicros,
  timeNanos;

  static OutputProperty fromString(String str) {
    return switch (str) {
      'status' => OutputProperty.status,
      'value' => OutputProperty.value,
      'time' => OutputProperty.time,
      'time_sec' => OutputProperty.timeSec,
      'time_millis' => OutputProperty.timeMillis,
      'time_micros' => OutputProperty.timeMicros,
      'time_nanos' => OutputProperty.timeNanos,
      _ => throw Exception("invalid OutputProperty: $str"),
    };
  }

  String get name {
    return switch (this) {
      OutputProperty.status => 'status',
      OutputProperty.value => 'value',
      OutputProperty.time => 'time',
      OutputProperty.timeSec => 'time_sec',
      OutputProperty.timeMillis => 'time_millis',
      OutputProperty.timeMicros => 'time_micros',
      OutputProperty.timeNanos => 'time_nanos',
    };
  }
}

enum Packer {
  no,
  json,
  msgpack;

  static Packer fromString(String str) {
    return switch (str) {
      'no' => Packer.no,
      'json' => Packer.json,
      'msgpack' => Packer.msgpack,
      _ => throw Exception('invalid Packer: $str'),
    };
  }
}
