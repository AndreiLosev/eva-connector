import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller.dart';

class Factory {
  BaseSvc makeSvc(Map map) {
    final svc = switch (map['command']) {
      ModbusController.svcCommand => ModbusController(map['oid']),
      _ => throw Exception("invelid svc command: ${map['command']}"),
    };

    svc.loadFromMap(map);

    return svc;
  }

  Item makeItem(Map map) {
    final oid = map['oid'];
    if (oid is! String) {
      throw Exception("is not item: $oid");
    }

    final result = switch (oid.split(":").first) {
      Sensor.name => Sensor(oid),
      Unit.name => Unit(oid),
      Lvar.name => Lvar(oid),
      Lmacro.name => Lmacro(oid),
      _ => throw Exception("is not item: $oid"),
    };

    result.loadFromMap(map);
    return result;
  }
}
