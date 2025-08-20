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
  real,
  real32,
  real64,
  real32b,
  real64b,
  uint16,
  word,
  uint32,
  dword,
  sint16,
  int16,
  sint32,
  int32,
  sint64,
  int64,
  uint64,
  qword;

  static ModbusValueType fromString(String? str) {
    if (str == null) {
      return ModbusValueType.uint16;
    }
    return switch (str) {
      'real' => ModbusValueType.real,
      'real32' => ModbusValueType.real32,
      'real64' => ModbusValueType.real64,
      'real32b' => ModbusValueType.real32b,
      'real64b' => ModbusValueType.real64b,
      'uint16' => ModbusValueType.uint16,
      'word' => ModbusValueType.word,
      'uint32' => ModbusValueType.uint32,
      'dword' => ModbusValueType.dword,
      'sint16' => ModbusValueType.sint16,
      'int16' => ModbusValueType.int16,
      'sint32' => ModbusValueType.sint32,
      'int32' => ModbusValueType.int32,
      'sint64' => ModbusValueType.sint64,
      'int64' => ModbusValueType.int64,
      'uint64' => ModbusValueType.uint64,
      'qword' => ModbusValueType.qword,
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
      'multiply' => ModbusTrasformFunc.multiply,
      'divide' => ModbusTrasformFunc.divide,
      'round' => ModbusTrasformFunc.round,
      'calc_speed' => ModbusTrasformFunc.calcSpeed,
      'invalid' => ModbusTrasformFunc.invert,
      _ => throw Exception('invalid ModbusTrasformFunc: $str'),
    };
  }
}
