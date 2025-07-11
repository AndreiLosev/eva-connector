import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';
import 'package:eva_connector/src/eva-config/svcs/s7_controller/action_map.dart';
import 'package:eva_connector/src/eva-config/svcs/s7_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/s7_controller/pull_config.dart';

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
