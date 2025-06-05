import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';
import 'package:eva_connector/src/eva-config/svcs/s7_controller/enums.dart';

class S7Config extends ISvcConfig {
  String ip = "127.0.0.1";
  int port = 102;
  int rack = 0;
  int slot = 0;
  int connectionType = 3;
  int pullCacheSec = 3600;
  double pullInterval = 2;
  List<PullConfig> pull = [];
  Map<String, ActionMap> actionMap = {};

  @override
  void loadFromMap(Map data) {
    ip = data['ip'];
    port = data['port'];
    rack = data['rack'];
    slot = data['slot'];
    connectionType = data['connection_type'];
    pullCacheSec = data['pull_cache_sec'];
    pullInterval = data['pull_interval'].toDouble();
    pull = (data['pull'] as List).map((e) => PullConfig.fromMap(e)).toList();
    actionMap = (data['action_map'] as Map).map(
      (k, v) => MapEntry(k as String, ActionMap.fromMap(v)),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'ip': ip,
      'port': port,
      'rack': rack,
      'slot': slot,
      'connection_type': connectionType,
      'pull_cache_sec': pullCacheSec,
      'pull_interval': pullInterval,
      'pull': pull.map((e) => e.toMap()).toList(),
      'action_map': actionMap.map((k, v) => MapEntry(k, v.toMap())),
    };
  }
}

class PullConfig {
  S7Area area = DataBlock(1);
  bool singleRequest = false;
  List<OffsetMap> map = [];

  static PullConfig fromMap(Map map) {
    final res = PullConfig();
    res.area = S7Area.fromString(map['area']);
    res.singleRequest = map['single_request'];
    res.map = (map['map'] as List).map((e) => OffsetMap.fromMap(e)).toList();

    return res;
  }

  Map<String, dynamic> toMap() {
    return {
      'area': area,
      'single_request': singleRequest,
      'map': map.map((e) => e.toMap()).toList(),
    };
  }
}

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

class ActionMap {
  S7Area area = DataBlock(1);
  (int, int?) offset = (1, null);
  S7Type? type;

  ActionMap();

  static ActionMap fromMap(Map map) {
    final res = ActionMap();
    res.area = S7Area.fromString(map['area']);
    res.offset = parseOffset(map['offset']);
    res.type = S7Type.fromString(map['type']);

    return res;
  }

  Map<String, dynamic> toMap() {
    final res = {'area': area, 'offset': offset};
    if (type != null) {
      res['type'] = type!;
    }
    return res;
  }
}
