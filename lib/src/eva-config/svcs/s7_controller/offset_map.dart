import 'package:eva_connector/src/eva-config/svcs/modbus_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/s7_controller/enums.dart';

class OffsetMap {
  (int, int?) offset = (1, null);
  String oid;
  S7Type? type;
  double? valueDelta;
  List<({ModbusTrasformFunc func, List<int> params})>? transform;

  OffsetMap(this.oid);

  static OffsetMap fromMap(Map map) {
    final res = OffsetMap(map['oid']);
    res.offset = parseOffset(map['offset']);
    res.type = S7Type.fromString(map['type']);
    res.valueDelta = map['value_delta']?.toDouble();
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

  Map<String, dynamic> toMap() {
    return {
      'offset': offset.$2 == null ? offset.$1 : "${offset.$1}/${offset.$2}",
      'oid': oid,
      if (type != null) 'type': type.toString(),
      if (valueDelta != null) 'value_delta': valueDelta,
      if (transform != null)
        'transform': transform?.map(
          (e) => {'func': e.func.toString(), 'params': e.params},
        ),
    };
  }
}
