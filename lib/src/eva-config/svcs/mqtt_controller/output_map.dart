import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/enums.dart';

class OutputMap implements Serializable {
  String path = r'$.';
  String oid;
  Process prop = Process.value;
  Map<String, dynamic>? valueMap;
  List<({ModbusTrasformFunc func, List<int> params})>? transform;
  dynamic payload;

  OutputMap(this.oid);

  @override
  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'oid': oid,
      'prop': prop.name,
      'value_map': valueMap,
      'transform': transform?.map(
        (e) => {'func': e.func.toString(), 'params': e.params},
      ),
      'payload': payload,
    };
  }

  @override
  void loadFromMap(Map map) {
    path = map['path'];
    oid = map['oid'];
    prop = Process.fromString(map['prop'] ?? 'value');
    valueMap = map['value_map'];
    transform = map['transform'] is List
        ? map['transform']
              .map(
                (e) => (
                  func: ModbusTrasformFunc.fromString(e['func']),
                  params: (e['params'] as List).map((e) => e as int).toList(),
                ),
              )
              .toList()
        : null;

    payload = map['payload'];
  }
}
