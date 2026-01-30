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
      'action_map': actionMap.map(
        (k, v) => MapEntry(k, v.toMap(modbus.protocol)),
      ),
    };
  }

  @override
  void loadFromMap(Map map) {
    actionQueueSize = map['action_queue_size'] as int? ?? actionQueueSize;
    actionsVerify = map['actions_verify'] as bool? ?? actionsVerify;
    
    // Безопасная обработка modbus
    if (map['modbus'] != null) {
      modbus = (
        path: map['modbus']['path'] as String? ?? modbus.path,
        protocol: map['modbus']['protocol'] != null
            ? ModbusProtocol.fromString(map['modbus']['protocol'] as String)
            : modbus.protocol,
        unit: map['modbus']['unit'] as int? ?? modbus.unit,
      );
    }
    
    panicIn = map['panic_in'] as int?;
    pullCacheSec = map['pull_cache_sec'] as int? ?? pullCacheSec;
    pullInterval = map['pull_interval'] as int? ?? pullInterval;
    queueSize = map['queue_size'] as int? ?? queueSize;
    retries = map['retries'] as int? ?? retries;
    
    // Безопасная обработка pull
    pull.clear();
    if (map['pull'] != null) {
      for (var item in map['pull'] as List) {
        pull.add(PullItem.fromMap(item as Map));
      }
    }

    // Безопасная обработка action_map
    actionMap.clear();
    if (map['action_map'] != null) {
      actionMap = (map['action_map'] as Map).map(
        (k, v) => MapEntry(k as String, ActionMapItem.loadFromMap(v as Map)),
      );
    }
  }
}
