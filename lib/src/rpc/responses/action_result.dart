import 'package:eva_connector/eva_connector.dart';
import 'package:uuid/uuid.dart';

class ActionResult {
  final dynamic err;
  final int? exitcode;
  final bool finished;
  final String node;
  final String oid;
  final Object? out;
  final Object? params;
  final int priority;
  final String status;
  final String svc;
  final Time time;
  final List<int> uuid;

  ActionResult({
    required this.err,
    required this.exitcode,
    required this.finished,
    required this.node,
    required this.oid,
    required this.out,
    required this.params,
    required this.priority,
    required this.status,
    required this.svc,
    required this.time,
    required this.uuid,
  });

  factory ActionResult.fromMap(Map<String, dynamic> map) {
    return ActionResult(
      err: map['err'],
      exitcode: map['exitcode'],
      finished: map['finished'],
      node: map['node'],
      oid: map['oid'],
      out: map['out'],
      params: map['params'],
      priority: map['priority'],
      status: map['status'],
      svc: map['svc'],
      time: Time.fromMap((map['time'] as Map).cast()),
      uuid: (map['uuid'] as List).cast(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'err': err,
      'exitcode': exitcode,
      'finished': finished,
      'node': node,
      'oid': oid,
      'out': out,
      'params': params,
      'priority': priority,
      'status': status,
      'svc': svc,
      'time': time.toMap(),
      'uuid': Uuid.unparse(uuid),
    };
  }
}

class Time {
  final DateTime? accepted;
  final DateTime? completed;
  final DateTime? created;
  final DateTime? pending;
  final DateTime? running;

  Time({
    required this.accepted,
    required this.completed,
    required this.created,
    required this.pending,
    required this.running,
  });

  factory Time.fromMap(Map<String, dynamic> map) {
    return Time(
      accepted: (map['accepted'] as double?)?.toDateTime(),
      completed: (map['completed'] as double?)?.toDateTime(),
      created: (map['created'] as double?)?.toDateTime(),
      pending: (map['pending'] as double?)?.toDateTime(),
      running: (map['running'] as double?)?.toDateTime(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accepted': accepted?.toString(),
      'completed': completed?.toString(),
      'created': created?.toString(),
      'pending': pending?.toString(),
      'running': running?.toString(),
    };
  }
}
