sealed class ModbusRegister {
  final int value;

  ModbusRegister(this.value);

  @override
  String toString() {
    return switch (this) {
      Holding() => "h$value",
      Input() => "i$value",
      Discrete() => "d$value",
      Coils() => "c$value",
    };
  }

  static ModbusRegister fromString(String str) {
    final t = str.substring(0, 1);
    final v = int.parse(str.substring(1));
    return switch (t) {
      'h' => Holding(v),
      'i' => Input(v),
      'd' => Discrete(v),
      'c' => Coils(v),
      _ => throw Exception('invalid modubs register type $str'),
    };
  }
}

class Holding extends ModbusRegister {
  Holding(super.value);
}

class Input extends ModbusRegister {
  Input(super.value);
}

class Discrete extends ModbusRegister {
  Discrete(super.value);
}

class Coils extends ModbusRegister {
  Coils(super.value);
}
