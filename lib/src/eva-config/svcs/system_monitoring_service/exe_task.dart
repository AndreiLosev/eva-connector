import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/exe_task_map.dart';

class ExeTask {
  String command = '';
  String name = '';
  bool enabled = false;
  int interval = 1;
  List<ExeTaskMap> map = [];
  List<String> ismap = [];
  String? user;

  ExeTask();

  ExeTask.fromMap(Map<String, dynamic> map) {
    command = map['command'] ?? '';
    name = map['name'] ?? '';
    enabled = map['enabled'] ?? false;
    interval = map['interval'] ?? 1;

    if (map['map'] is List) {
      this.map = (map['map'] as List)
          .map((m) => ExeTaskMap.fromMap(m as Map<String, dynamic>))
          .toList();
    }

    if (map['ismap'] is List) {
      ismap = (map['ismap'] as List).map((e) {
        if (e is Map) {
          return e['name']?.toString() ?? '';
        }
        return e.toString();
      }).toList();
    }

    user = map['user'] as String?;
  }

  Map<String, dynamic> toMap() => {
    'command': command,
    'name': name,
    'enabled': enabled,
    'interval': interval,
    'map': map.map((m) => m.toMap()).toList(),
    if (ismap.isNotEmpty)
      'ismap': ismap.map((name) => {'name': name}).toList(),
    if (user != null) 'user': user,
  };
}
