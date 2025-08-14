import 'package:eva_connector/src/eva-config/svcs/modbus_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/modbus_register.dart';

class ActionMapItem {
  ModbusRegister reg = Holding(0);
  ModbusValueType? type = ModbusValueType.uint16;
  int? unit;

  Map<String, dynamic> toMap([ModbusProtocol? protocol]) {
    return {
      'reg': reg.toString(),
      if ([Holding, Input].contains(reg.runtimeType)) 'type': type.toString(),
      if (unit != null && (protocol == ModbusProtocol.rtu || protocol == null))
        'unit': unit,
    };
  }

  static ActionMapItem loadFromMap(Map map) {
    final res = ActionMapItem();
    res.reg = ModbusRegister.fromString(map['reg']);
    res.type = ModbusValueType.fromString(map['type']);
    res.unit = map['unit'];

    return res;
  }
}
