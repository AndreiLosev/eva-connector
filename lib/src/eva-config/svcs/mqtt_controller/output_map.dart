import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/enums.dart';

class OutputMap implements Serializable {
  String path = r'$.';
  String? oid;
  OutputProperty? prop;
  Map<dynamic, dynamic>? valueMap;
  List<({ModbusTrasformFunc func, List<int> params})>? transform;
  dynamic payload;

  OutputMap([this.oid]);

  @override
  Map<String, dynamic> toMap() {
    return {
      'path': path,
      if (oid != null) 'oid': oid,
      if (prop != null) 'prop': prop!.name,
      if (valueMap != null)
        'value_map': Map.fromIterables(
          valueMap!.keys.map((e) => e.toString()),
          valueMap!.values,
        ),
      if (transform != null)
        'transform': transform!.map(
          (e) => {'func': e.func.toString(), 'params': e.params},
        ),
      if (payload != null) 'payload': payload,
    };
  }

  @override
  void loadFromMap(Map map) {
    path = map['path'] ?? r'$.';
    oid = map['oid'];
    prop = map['prop'] != null ? OutputProperty.fromString(map['prop']) : null;
    valueMap = (map['value_map'] as Map?)?.cast();
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
