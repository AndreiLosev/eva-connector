import 'package:eva_connector/src/eva-config/svcs/modbus_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/modbus_register.dart';

class ActionMapItem {
  ModbusRegister reg = Holding(0);
  ModbusValueType? type = ModbusValueType.uint16;
  int? unit;

  Map<String, dynamic> toMap() {
    return Map.fromEntries(
      [
        MapEntry('reg', reg.toString()),
        MapEntry('type', type?.toString()),
        MapEntry('unit', unit),
      ].where((e) => e.value != null),
    );
  }

  static ActionMapItem loadFromMap(Map map) {
    final res = ActionMapItem();
    res.reg = ModbusRegister.fromString(map['reg']);
    res.type = ModbusValueType.fromString(map['type']);
    res.unit = map['unit'];

    return res;
  }
}
