import 'package:eva_connector/src/eva-config/svcs/modbus_controller/export.dart';

class PullItem {
  ModbusRegister reg = Holding(1);
  int count = 1;
  int? unit;
  List<MapItem> map = [];

  PullItem();

  Map<String, dynamic> toMap([ModbusProtocol? protocol]) {
    return {
      'count': count,
      'reg': reg.toString(),
      'map': map.map((i) => i.toMap(reg)).toList(),
      if (unit is int && (ModbusProtocol.rtu == protocol || protocol == null))
        'unit': unit,
    };
  }

  factory PullItem.fromMap(Map map) {
    final res = PullItem();
    res.reg = ModbusRegister.fromString(map['reg']);
    res.count = map['count'];
    res.unit = map['unit'];
    for (var item in map['map']) {
      res.map.add(MapItem.loadFromMap(item));
    }

    return res;
  }
}
