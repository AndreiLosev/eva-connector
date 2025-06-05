import 'package:eva_connector/src/eva-config/svcs/s7_controller/enums.dart';

class OffsetMap {
  (int, int?) offset = (1, null);
  String oid;
  S7Type? type;
  double? valueDelta;
  List<Transform>? transform;

  OffsetMap(this.oid);

  static OffsetMap fromMap(Map map) {
    final res = OffsetMap(map['oid']);
    res.offset = parseOffset(map['offset']);
    res.type = S7Type.fromString(map['type']);
    res.valueDelta = map['value_delta']?.toDouble();
    res.transform = map['transform'] != null
        ? (map['transform'] as List).map((e) => Transform.fromMap(e)).toList()
        : null;

    return res;
  }

  Map<String, dynamic> toMap() {
    return {
      'offset': offset.$2 == null ? offset.$1 : "${offset.$1}/${offset.$2}",
      'oid': oid,
      if (type != null) 'type': type,
      if (valueDelta != null) 'value_delta': valueDelta,
      if (transform != null)
        'transform': transform!.map((e) => e.toMap()).toList(),
    };
  }
}

class Transform {
  TransformFunc func;
  List<dynamic> params;

  Transform({required this.func, required this.params});

  static Transform fromMap(Map map) {
    return Transform(
      func: TransformFunc.values.byName(map['func']),
      params: map['params'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {'func': func.name, 'params': params};
  }
}
