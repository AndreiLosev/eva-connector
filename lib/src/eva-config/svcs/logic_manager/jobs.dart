class Job {
  String id;
  String schedule = '0 * * * * *';
  String run;
  List<dynamic> args = [];
  Map<String, dynamic> kwargs = {};

  Job(this.id, this.run);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schedule': schedule,
      'run': run,
      'args': args,
      'kwargs': kwargs,
    };
  }

  void loadFromMap(Map<String, dynamic> map) {
    id = map['id'] as String? ?? '';
    schedule = map['schedule'] as String? ?? '0 * * * * *';
    run = map['run'] as String? ?? '';
    args = map['args'] as List<dynamic>? ?? [];
    kwargs = map['kwargs'] as Map<String, dynamic>? ?? {};
  }
}
