import 'package:eva_connector/src/eva-config/svcs/modbus_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/modbus_register.dart';

class MapItem {
  (int, int?) offset = (0, null);
  String oid;
  ModbusValueType? type = ModbusValueType.uint16;
  double? valueDelta = 0.1;
  List<({ModbusTrasformFunc func, List<int> params})>? transform;

  MapItem(this.oid);

  Map toMap([ModbusRegister? reg]) {
    return {
      'offset': offset.$2 == null ? offset.$1 : "${offset.$1}/${offset.$2}",
      if ([Holding, Input].contains(reg?.runtimeType)) 'type': type?.toString(),
      'oid': oid,
      if (valueDelta != null && (type?.name.startsWith('real') ?? false))
        'value_delta': valueDelta,
      if (transform != null)
        'transform': transform
            ?.map((e) => {'func': e.func, 'params': e.params})
            .toList(),
    };
  }

  static MapItem loadFromMap(Map map) {
    final res = MapItem(map['oid']);
    res.offset = _parseOffset(map['offset']);
    res.type = ModbusValueType.fromString(map['type']);
    res.valueDelta = map['value_delta'];
    res.transform = map['transform'] is List
        ? map['transform']
              .map(
                (e) => (
                  func: ModbusTrasformFunc.fromString(e['func']),
                  params: (e['params'] as List).map((e) => e as int).toList(),
                ),
              )
              .toList()
        : null;

    return res;
  }

  static (int, int?) _parseOffset(Object mOffset) {
    if (mOffset is int) {
      return (mOffset, null);
    }

    if (mOffset is String &&
        RegExp("^[0-9]+/[0-9]+\$").firstMatch(mOffset) != null) {
      final arr = mOffset.split('/');
      return (int.parse(arr.first), int.parse(arr.last));
    }

    throw Exception('invelid offset: $mOffset');
  }
}
