import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class DbSqlConfig extends ISvcConfig {
  String db = 'postgres://USER:PASSWORD@HOST/DB';
  int? bufTtlSec;
  int? interval;
  bool skipDisconnected = false;
  bool ignoreEvents = false;
  int? keep = 604800;
  bool? cleanupOids;
  int queueSize = 8192;
  int panicIn = 0;
  int? poolSize;
  List<String> oids = ['#'];
  List<String> oidsExclude = [];
  bool? evaPg;
  List<String> oidsExcludeNull = [];

  @override
  Map<String, dynamic> toMap() {
    return {
      'db': db,
      'buf_ttl_sec': bufTtlSec,
      'interval': interval,
      'skip_disconnected': skipDisconnected,
      'ignore_events': ignoreEvents,
      'keep': keep,
      'cleanup_oids': cleanupOids,
      'queue_size': queueSize,
      'panic_in': panicIn,
      'pool_size': poolSize,
      'oids': oids,
      'oids_exclude': oidsExclude,
      'eva_pg': evaPg,
      'oids_exclude_null': oidsExcludeNull,
    };
  }

  @override
  void loadFromMap(Map<dynamic, dynamic> map) {
    db = map['db'];
    bufTtlSec = map['buf_ttl_sec'];
    interval = map['interval'];
    skipDisconnected = map['skip_disconnected'];
    ignoreEvents = map['ignore_events'];
    keep = map['keep'];
    cleanupOids = map['cleanup_oids'];
    queueSize = map['queue_size'];
    panicIn = map['panic_in'];
    poolSize = map['pool_size'];
    oids = List<String>.from(map['oids'] ?? ['#']);
    oidsExclude = List<String>.from(map['oids_exclude'] ?? []);
    evaPg = map['eva_pg'];
    oidsExcludeNull = List<String>.from(map['oids_exclude_null'] ?? []);
  }
}
