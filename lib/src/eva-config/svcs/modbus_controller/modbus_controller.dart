import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/modbus_config.dart';

class ModbusController extends BaseSvc<ModbusConfig> {
  static const svcCommand = "svc/eva-controller-modbus";

  ModbusController(String id)
    : super(id, ModbusController.svcCommand, ModbusConfig());
}
