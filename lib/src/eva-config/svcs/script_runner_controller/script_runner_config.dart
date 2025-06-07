import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';
import 'package:eva_connector/src/eva-config/svcs/script_runner_controller/action_map.dart';
import 'package:eva_connector/src/eva-config/svcs/script_runner_controller/update_pipe.dart';

class ScriptRunnerConfig extends ISvcConfig {
  List<UpdateCommand>? update;
  List<UpdatePipe>? updatePipe;
  Map<String, ActionMap>? actionMap;
  int queueSize = 2048;
  int actionQueueSize = 32;

  @override
  Map<String, dynamic> toMap() {
    return {
      'update': update?.map((e) => e.toMap()).toList(),
      if (updatePipe != null)
        'update_pipe': updatePipe!.map((e) => e.toMap()).toList(),
      'action_map': actionMap?.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
      'queue_size': queueSize,
      'action_queue_size': actionQueueSize,
    };
  }

  @override
  void loadFromMap(Map map) {
    update?.clear();
    update?.addAll(
      (map['update'] as List)
          .where((e) => e['command'] is String && e['oid'] is List)
          .map((e) => UpdateCommand(e['command'], e['oid'])..loadFromMap(e)),
    );

    if (map.containsKey('update_pipe')) {
      updatePipe?.clear();
      updatePipe?.addAll(
        (map['update_pipe'] as List)
            .where((e) => e['command'] is String && e['process'] is String)
            .map((e) => UpdatePipe(e['command'], e['process'])),
      );
    }

    actionMap?.clear();
    (map['action_map'] as Map).forEach((key, value) {
      actionMap?[key as String] = ActionMap(value['command'])
        ..loadFromMap(value);
    });

    queueSize = map['queue_size'] as int;
    actionQueueSize = map['action_queue_size'] as int;
  }
}
