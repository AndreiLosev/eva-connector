enum Process {
  value,
  status;

  static Process fromString(String str) {
    return switch (str) {
      'value' => Process.value,
      'status' => Process.status,
      _ => throw Exception("invalid Propcess: $str"),
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
