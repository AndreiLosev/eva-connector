import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/db_sql/db_sql_history.dart';
import 'package:eva_connector/src/eva-config/svcs/hmi_service/hmi_service.dart';
import 'package:eva_connector/src/eva-config/svcs/item_state_expiration_service/item_state_expiration_service.dart';
import 'package:eva_connector/src/eva-config/svcs/logic_manager/logic_manager.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/modbus_controller.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/mqtt_controller.dart';
import 'package:eva_connector/src/eva-config/svcs/py_macros/py_macros.dart';
import 'package:eva_connector/src/eva-config/svcs/s7_controller/s7_controller.dart';
import 'package:eva_connector/src/eva-config/svcs/script_runner_controller/script_runner_controller.dart';
import 'package:eva_connector/src/eva-config/svcs/shared_lock_service/shared_lock_service.dart';
import 'package:eva_connector/src/exceptions/unsupported_service.dart';

class Factory {
  BaseSvc makeSvc(String id, Map map) {
    final BaseSvc svc = switch (map['command']) {
      ModbusController.svcCommand => ModbusController(id),
      S7Controller.svcCommand => S7Controller(id),
      DbSqlHistory.svcCommand => DbSqlHistory(id),
      LogicManager.svcCommand => LogicManager(id),
      PyMacros.svcCommand => PyMacros(id),
      SharedLockService.svcCommand => SharedLockService(id),
      ItemStateExpirationService.svcCommand => ItemStateExpirationService(id),
      MqttController.svcCommand => MqttController(id),
      HmiService.svcCommand => HmiService(id),
      ScriptRunnerController.svcCommand => ScriptRunnerController(id),
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
