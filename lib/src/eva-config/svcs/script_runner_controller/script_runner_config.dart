import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';
import 'package:eva_connector/src/eva-config/svcs/script_runner_controller/action_map.dart';
import 'package:eva_connector/src/eva-config/svcs/script_runner_controller/update_command.dart';
import 'package:eva_connector/src/eva-config/svcs/script_runner_controller/update_pipe.dart';

class ScriptRunnerConfig extends ISvcConfig {
  List<UpdateCommand>? update;
  List<UpdatePipe>? updatePipe;
  Map<String, ScriptActionMap>? actionMap;
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
    final newUpdate = (map['update'] as List?)
        ?.where((e) => e['command'] is String && e['oid'] is List)
        .map(
          (e) =>
              UpdateCommand(e['command'], (e['oid'] as List).cast())
                ..loadFromMap(e),
        );
    update = (newUpdate?.isNotEmpty ?? false) ? newUpdate!.toList() : null;

    final newUpdatePipe = (map['update_pipe'] as List?)
        ?.where((e) => e['command'] is String && e['process'] is String)
        .map((e) => UpdatePipe(e['command'], e['process']));

    updatePipe = (newUpdatePipe?.isNotEmpty ?? false) ? newUpdatePipe!.toList() : null;

    actionMap = (map['action_map'] as Map?)?.map(
      (k, v) => MapEntry(k.toString(), ScriptActionMap(v['command'])..loadFromMap(v)),
    );

    queueSize = map['queue_size'] as int? ?? queueSize;
    actionQueueSize = map['action_queue_size'] as int? ?? actionQueueSize;
  }
}
