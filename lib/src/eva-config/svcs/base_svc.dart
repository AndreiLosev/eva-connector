import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/eva-config/svcs/bus.dart';

class BaseSvc<T extends Serializable> implements Serializable {
  String oid;
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

  T? config;

  BaseSvc(this.oid, this.command);

  @override
  Map<String, dynamic> toMap() {
    return {
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
      'config': config?.toMap(),
    };
  }

  @override
  void loadFromMap(Map map) {
    bus.loadFromMap(map['bus']);
    callTracing = map['call_tracing'];
    command = map['command'];
    user = map['user'];
    workers = map['workers'];
    enabled = map['enabled'];
    launcher = map['launcher'];
    memWarn = map['mem_warn'];
    prepareCommand = map['prepare_command'];
    reactToFail = map['react_to_fail'];
    timeout = (
      default1: map['timeout']['default'],
      shutdown: map['timeout']['shutdown'],
      startup: map['timeout']['startup'],
    );
    config?.loadFromMap(map['config']);
  }
}
