import 'package:eva_connector/eva_connector.dart';

class ActionResult {
  final dynamic err;
  final int? exitcode;
  final bool finished;
  final String node;
  final String oid;
  final Object? out;
  final ActionParams params;
  final int priority;
  final String status;
  final String svc;
  final Time time;
  final List<dynamic> uuid;

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
      params: ActionParams.fromMap((map['params'] as Map).cast()),
      priority: map['priority'],
      status: map['status'],
      svc: map['svc'],
      time: Time.fromMap((map['time'] as Map).cast()),
      uuid: map['uuid'],
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
      'params': params.toMap(),
      'priority': priority,
      'status': status,
      'svc': svc,
      'time': time.toMap(),
      'uuid': uuid,
    };
  }
}

class ActionParams {
  final int? status;
  final int? value;

  ActionParams({required this.status, required this.value});

  factory ActionParams.fromMap(Map<String, dynamic> map) {
    return ActionParams(status: map['status'], value: map['value']);
  }

  Map<String, dynamic> toMap() {
    return {'status': status, 'value': value};
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
