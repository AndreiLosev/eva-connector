import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/enums.dart';

class ActionMapItem implements Serializable {
  String path = r'$.';
  Map<String, dynamic>? valueMap;
  List<({ModbusTrasformFunc func, List<int> params})>? transform;

  ActionMapItem();

  @override
  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'value_map': valueMap,
      'transform': transform?.map(
        (e) => {'func': e.func.toString(), 'params': e.params},
      ),
    };
  }

  @override
  void loadFromMap(Map map) {
    path = map['path'] ?? r'$.';
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
  }
}
