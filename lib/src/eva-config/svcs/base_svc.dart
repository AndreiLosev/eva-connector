import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/eva-config/svcs/bus.dart';
import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class BaseSvc<T extends ISvcConfig> implements Serializable {
  String id;
  final bus = Bus();

  bool callTracing = false;
  String command;
  String user = 'nobody';
  int workers = 1;
  bool enabled = true;
  String launcher = 'eva.launcher.main';
  int memWarn = 134217728;
  String? prepareCommand;
  bool reactToFail = true;
  ({double? default1, double? shutdown, double? startup}) timeout = (
    default1: null,
    shutdown: null,
    startup: 10.0,
  );

  T config;

  BaseSvc(this.id, this.command, this.config);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'params': {
        'bus': bus.toMap(),
        'call_tracing': callTracing,
        'command': command,
        'user': user,
        'workers': workers,
        'enabled': enabled,
        'launcher': launcher,
        'mem_warn': memWarn,
        'prepare_command': prepareCommand,
        'react_to_fail': reactToFail,
        'timeout': {
          'default': timeout.default1,
          'shutdown': timeout.shutdown,
          'startup': timeout.startup,
        },
        'config': config.toMapEmpty(),
      },
    };
  }

  @override
  void loadFromMap(Map map) {
    bus.loadFromMap(map['bus']);
    callTracing = map['call_tracing'] ?? callTracing;
    command = map['command'];
    user = map['user'] ?? 'nobody';
    workers = map['workers'] ?? workers;
    enabled = map['enabled'] ?? enabled;
    launcher = map['launcher'] ?? launcher;
    memWarn = map['mem_warn'] ?? memWarn;
    prepareCommand = map['prepare_command'];
    reactToFail = map['react_to_fail'] ?? reactToFail;
    if (map['timeout'] != null) {
      timeout = (
        default1: (map['timeout']['default'] as num?)?.toDouble(),
        shutdown: (map['timeout']['shutdown'] as num?)?.toDouble(),
        startup:
            (map['timeout']['startup'] as num?)?.toDouble() ?? timeout.startup,
      );
    }
    config.loadFromMapEmpty(map['config']);
  }
}
