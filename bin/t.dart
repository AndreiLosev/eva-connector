import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/export.dart';

void main(List<String> args) {
  final x = InputMap('sensor:test1/val1');
  x.transform = [
    (func: ModbusTrasformFunc.multiply, params: [2]),
    (func: ModbusTrasformFunc.round, params: [2]),
  ];

  print(x.toMap());
  print(YamlWriter().write(x.toMap()));
}
