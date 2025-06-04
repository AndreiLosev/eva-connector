import 'package:eva_connector/src/eva-config/enum_to_strig.dart';
import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class ModbusController extends BaseSvc<ModbusConfig> {
  static const svcCommand = "svc/eva-controller-modbus";

  ModbusController(String oid)
    : super(oid, ModbusController.svcCommand, ModbusConfig());
}

class ModbusConfig extends ISvcConfig implements Serializable {
  int actionQueueSize = 32;
  bool actionsVerify = true;
  ({String path, ModbusProtocol protocol, int unit}) modbus = (
    path: "127.0.0.1:502",
    protocol: ModbusProtocol.tcp,
    unit: 1,
  );
  String? panicIn;
  int pullCacheSec = 360;
  int pullInterval = 2;
  int queueSize = 32768;
  int retries = 2;

  List<({int count, int? unit, ModbusRegister reg, List<MapItem> map})> pull =
      [];
  Map<String, ActionMapItem> actionMap = {};

  @override
  Map<String, dynamic> toMap() {
    return {
      'action_queue_size': actionQueueSize,
      'actions_verify': actionsVerify,
      'modbus': {
        'path': modbus.path,
        'protocol': modbus.protocol.toString(),
        'unit': modbus.unit,
      },
      'panic_in': panicIn,
      'pull_cache_sec': pullCacheSec,
      'pull_interval': pullInterval,
      'queue_size': queueSize,
      'retries': retries,
      'pull': pull
          .map(
            (e) => Map.fromEntries(
              [
                MapEntry('count', e.count),
                MapEntry('unit', e.unit),
                MapEntry('reg', e.reg.toString()),
                MapEntry('map', e.map.map((i) => i.toMap()).toList()),
              ].where((e) => e.value != null),
            ),
          )
          .toList(),
      'action_map': actionMap.map((k, v) => MapEntry(k, v.toMap())),
    };
  }

  @override
  void loadFromMap(Map map) {
    actionQueueSize = map['action_queue_size'];
    actionsVerify = map['actions_verify'];
    modbus = (
      path: map['modbus']['path'] as String,
      protocol: ModbusProtocol.fromString(map['modbus']['protocol']),
      unit: map['modbus']['unit'] as int,
    );
    panicIn = map['panic_in'];
    pullCacheSec = map['pull_cache_sec'];
    pullInterval = map['pull_interval'];
    queueSize = map['queue_size'];
    retries = map['retries'];
    pull = (map['pull'] as List)
        .map(
          (e) => (
            count: e['count'] as int,
            unit: e['unit'] as int?,
            reg: ModbusRegister.fromString(e['reg']),
            map: (e['map'] as List).map((e) => MapItem.loadFromMap(e)).toList(),
          ),
        )
        .toList();

    actionMap = (map['action_map'] as Map).map(
      (k, v) => MapEntry(k as String, ActionMapItem.loadFromMap(v)),
    );
  }
}

enum ModbusProtocol with EnumToStrig {
  tcp,
  udp,
  rtu;

  static ModbusProtocol fromString(String str) {
    return switch (str) {
      'tcp' => ModbusProtocol.tcp,
      'udp' => ModbusProtocol.udp,
      'rtu' => ModbusProtocol.rtu,
      _ => throw Exception('invalid ModbusProtocol: $str'),
    };
  }
}

class MapItem {
  (int, int?) offset = (0, null);
  String oid;
  ModbusValueType? type = ModbusValueType.uint16;
  double? valueDelta = 0.5;
  List<({ModbusTrasformFunc func, List<int> params})>? transform;

  MapItem(this.oid);

  Map<String, dynamic> toMap() {
    return Map.fromEntries(
      [
        MapEntry(
          'offset',
          offset.$2 == null ? offset.$1 : "${offset.$1}/${offset.$2}",
        ),
        MapEntry('oid', oid),
        MapEntry('type', type?.toString()),
        MapEntry('value_delta', valueDelta),
        MapEntry(
          'transform',
          transform?.map(
            (e) => {'func': e.func.toString(), 'params': e.params},
          ),
        ),
      ].where((e) => e.value != null),
    );
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

    if (mOffset is String) {
      final arr = mOffset.split('/');
      return (int.parse(arr.first), int.parse(arr.last));
    }

    throw Exception('invelid offset: $mOffset');
  }
}

class ActionMapItem {
  ModbusRegister reg = Holding(0);
  ModbusValueType? type = ModbusValueType.uint16;
  int? unit;

  Map<String, dynamic> toMap() {
    return Map.fromEntries(
      [
        MapEntry('reg', reg.toString()),
        MapEntry('type', type?.toString()),
        MapEntry('unit', unit),
      ].where((e) => e.value != null),
    );
  }

  static ActionMapItem loadFromMap(Map map) {
    final res = ActionMapItem();
    res.reg = ModbusRegister.fromString(map['reg']);
    res.type = ModbusValueType.fromString(map['type']);
    res.unit = map['unit'];

    return res;
  }
}

enum ModbusValueType with EnumToStrig {
  real,
  real32,
  real64,
  real32b,
  real64b,
  uint16,
  word,
  uint32,
  dword,
  sint16,
  int16,
  sing32,
  int32,
  sint64,
  int64,
  uint64,
  qword;

  static ModbusValueType? fromString(String? str) {
    if (str == null) {
      return null;
    }
    return switch (str) {
      'real' => ModbusValueType.real,
      'real32' => ModbusValueType.real32,
      'real64' => ModbusValueType.real64,
      'real32b' => ModbusValueType.real32b,
      'real64b' => ModbusValueType.real64b,
      'uint16' => ModbusValueType.uint16,
      'word' => ModbusValueType.word,
      'uint32' => ModbusValueType.uint32,
      'dword' => ModbusValueType.dword,
      'sint16' => ModbusValueType.sint16,
      'int16' => ModbusValueType.int16,
      'sint32' => ModbusValueType.sing32,
      'int32' => ModbusValueType.int32,
      'sint64' => ModbusValueType.sint64,
      'int64' => ModbusValueType.int64,
      'uint64' => ModbusValueType.uint64,
      'qword' => ModbusValueType.qword,
      _ => throw Exception('invalid value type: $str'),
    };
  }
}

enum ModbusTrasformFunc with EnumToStrig {
  multiply,
  divide,
  round,
  calcSpeed,
  invert;

  @override
  String toString() {
    if (this == calcSpeed) {
      return 'calc_speed';
    }

    return super.toString();
  }

  static ModbusTrasformFunc fromString(String str) {
    return switch (str) {
      'multiply' => ModbusTrasformFunc.multiply,
      'divide' => ModbusTrasformFunc.divide,
      'round' => ModbusTrasformFunc.round,
      'calc_speed' => ModbusTrasformFunc.calcSpeed,
      'invalid' => ModbusTrasformFunc.invert,
      _ => throw Exception('invalid ModbusTrasformFunc: $str'),
    };
  }
}

sealed class ModbusRegister {
  final int value;

  ModbusRegister(this.value);

  @override
  String toString() {
    return switch (this) {
      Holding() => "h$value",
      Input() => "i$value",
      Discrete() => "d$value",
      Coils() => "c$value",
    };
  }

  static ModbusRegister fromString(String str) {
    final t = str.substring(0, 1);
    final v = int.parse(str.substring(1));
    return switch (t) {
      'h' => Holding(v),
      'i' => Input(v),
      'd' => Discrete(v),
      'c' => Coils(v),
      _ => throw Exception('invalid modubs register type $str'),
    };
  }
}

class Holding extends ModbusRegister {
  Holding(super.value);
}

class Input extends ModbusRegister {
  Input(super.value);
}

class Discrete extends ModbusRegister {
  Discrete(super.value);
}

class Coils extends ModbusRegister {
  Coils(super.value);
}
