import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/action_map_item.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/pull_item.dart';

class ModbusConfig extends ISvcConfig {
  int actionQueueSize = 32;
  bool actionsVerify = true;
  ({String path, ModbusProtocol protocol, int unit}) modbus = (
    path: "127.0.0.1:502",
    protocol: ModbusProtocol.tcp,
    unit: 1,
  );
  int? panicIn;
  int pullCacheSec = 360;
  int pullInterval = 2;
  int queueSize = 32768;
  int retries = 2;

  List<PullItem> pull = [];
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
      'pull': pull.map((e) => e.toMap(modbus.protocol)).toList(),
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
    pull.clear();
    for (var item in map['pull']) {
      pull.add(PullItem.fromMap(item as Map));
    }

    actionMap = (map['action_map'] as Map).map(
      (k, v) => MapEntry(k as String, ActionMapItem.loadFromMap(v)),
    );
  }
}
