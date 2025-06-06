import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class DbSqlConfig extends ISvcConfig {
  String db = 'sqlite:///tmp/eva_history.db';
  int? bufTtlSec;
  int? interval;
  bool skipDisconnected = false;
  bool ignoreEvents = false;
  bool simpleCleaning = false;
  int keep = 604800;
  int queueSize = 8192;
  int panicIn = 0;
  List<String> oids = ['*'];
  List<String> oidsExclude = [];

  @override
  Map<String, dynamic> toMap() {
    return {
      'db': db,
      'buf_ttl_sec': bufTtlSec,
      'interval': interval,
      'skip_disconnected': skipDisconnected,
      'ignore_events': ignoreEvents,
      'simple_cleaning': simpleCleaning,
      'keep': keep,
      'queue_size': queueSize,
      'panic_in': panicIn,
      'oids': oids,
      'oids_exclude': oidsExclude,
    };
  }

  @override
  void loadFromMap(Map<dynamic, dynamic> map) {
    db = map['db'];
    bufTtlSec = map['buf_ttl_sec'];
    interval = map['interval'];
    skipDisconnected = map['skip_disconnected'];
    ignoreEvents = map['ignore_events'];
    simpleCleaning = map['simple_cleaning'];
    keep = map['keep'];
    queueSize = map['queue_size'];
    panicIn = map['panic_in'];
    oids = List<String>.from(map['oids']);
    oidsExclude = List<String>.from(map['oids_exclude']);
  }
}
