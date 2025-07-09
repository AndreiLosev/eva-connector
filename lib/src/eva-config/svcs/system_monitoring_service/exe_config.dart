import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/exe_task.dart';

class ExeConfig {
  List<ExeTask> tasks = [];

  ExeConfig();

  ExeConfig.fromMap(Map<String, dynamic> map) {
    if (map['tasks'] is List) {
      tasks = (map['tasks'] as List)
          .map((t) => ExeTask.fromMap(t as Map<String, dynamic>))
          .toList();
    }
  }

  Map<String, dynamic> toMap() => {
    'tasks': tasks.map((t) => t.toMap()).toList(),
  };
}
