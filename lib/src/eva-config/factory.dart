import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/modbus_controller.dart';
import 'package:eva_connector/src/eva-config/svcs/s7_controller/s7_controller.dart';
import 'package:eva_connector/src/exceptions/unsupported_service.dart';

class Factory {
  BaseSvc makeSvc(String oid, Map map) {
    final BaseSvc svc = switch (map['command']) {
      ModbusController.svcCommand => ModbusController(oid),
      S7Controller.svcCommand => S7Controller(oid),
      _ => throw UnsupportedService(map['command']),
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
