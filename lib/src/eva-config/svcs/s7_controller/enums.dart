import 'package:eva_connector/src/eva-config/enum_to_strig.dart';

enum S7Type with EnumToStrig {
  bool,
  byte,
  sint,
  usint,
  world,
  int,
  uint,
  dworld,
  dint,
  udint,
  real,
  lreal;

  static S7Type? fromString(String? type) {
    return switch (type) {
      'bool' => bool,
      'byte' => byte,
      'sint' => sint,
      'usint' => usint,
      'word' => world,
      'int' => int,
      'uint' => uint,
      'dword' => dworld,
      'dint' => dint,
      'udint' => udint,
      'real' => real,
      'lreal' => lreal,
      null => null,
      _ => throw Exception("undefinet type $type"),
    };
  }
}

sealed class S7Area {
  static S7Area fromString(String str) {
    final res = switch (str) {
      'M' => Merkers(),
      'I' => Inputs(),
      'Q' => Outputs(),
      _ => null,
    };

    if (res != null) {
      return res;
    }

    if (str.startsWith("DB")) {
      final dbNUmber = int.tryParse(str.substring(2));
      if (dbNUmber is int && dbNUmber != 0) {
        return DataBlock(dbNUmber);
      }
    }

    throw Exception("invalid S7Area: $str");
  }
}

class Merkers extends S7Area {
  @override
  String toString() {
    return "M";
  }
}

class Inputs extends S7Area {
  @override
  String toString() {
    return "I";
  }
}

class Outputs extends S7Area {
  @override
  String toString() {
    return "Q";
  }
}

class DataBlock extends S7Area {
  final int blockNumber;

  DataBlock(this.blockNumber);

  @override
  String toString() {
    return "DB$blockNumber";
  }
}

(int, int?) parseOffset(Object mOffset) {
  if (mOffset is int) {
    return (mOffset, null);
  }

  if (mOffset is String &&
      RegExp("^[0-9]+/[0-9]+\$").firstMatch(mOffset) != null) {
    final arr = mOffset.split('/');
    return (int.parse(arr.first), int.parse(arr.last));
  }

  throw Exception("invalid offset: $mOffset");
}
