import 'package:eva_connector/src/eva-config/enum_to_strig.dart';

enum ModbusProtocol with EnumToStrig {
  tcp,
  udp,
  rtu;

  static ModbusProtocol fromString(String str) {
    return switch (str) {
      'tcp' => ModbusProtocol.tcp,
      'udp' => ModbusProtocol.udp,
      'rtu' => ModbusProtocol.rtu,
      _ => throw Exception('invalid ModbusProtocol: $str'),
    };
  }
}

enum ModbusValueType with EnumToStrig {
  real32,
  real64,
  real32b,
  real64b,
  uint16,
  uint32,
  uint32w,
  int16,
  int32,
  int32w,
  int64,
  int64w,
  uint64,
  uint64w;

  static ModbusValueType fromString(String? str) {
    if (str == null) {
      return ModbusValueType.uint16;
    }
    return switch (str) {
      'real' => ModbusValueType.real32,
      'real32' => ModbusValueType.real32,
      'real64' => ModbusValueType.real64,
      'real32b' => ModbusValueType.real32b,
      'real64b' => ModbusValueType.real64b,
      'uint16' => ModbusValueType.uint16,
      'word' => ModbusValueType.uint16,
      'uint32' => ModbusValueType.uint32,
      'uint32w' => ModbusValueType.uint32w,
      'dword' => ModbusValueType.uint32,
      'sint16' => ModbusValueType.int16,
      'int16' => ModbusValueType.int16,
      'sint32' => ModbusValueType.int32,
      'int32' => ModbusValueType.int32,
      'int32w' => ModbusValueType.int32w,
      'sint64' => ModbusValueType.int64,
      'int64' => ModbusValueType.int64,
      'uint64' => ModbusValueType.uint64,
      'int64w' => ModbusValueType.int64w,
      'uint64w' => ModbusValueType.uint64w,
      'qword' => ModbusValueType.uint64,
      _ => throw Exception('invalid value type: $str'),
    };
  }
}

enum ModbusTrasformFunc with EnumToStrig {
  multiply,
  divide,
  round,
  calcSpeed,
  invert;

  @override
  String toString() {
    if (this == calcSpeed) {
      return 'calc_speed';
    }

    return super.toString();
  }

  static ModbusTrasformFunc fromString(String str) {
    return switch (str) {
      'multiply' => .multiply,
      'divide' => .divide,
      'round' => .round,
      'calc_speed' => .calcSpeed,
      'invalid' => .invert,
      _ => throw Exception('invalid ModbusTrasformFunc: $str'),
    };
  }
}
