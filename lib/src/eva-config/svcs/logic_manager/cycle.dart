class Cycle {
  String id;
  bool autoStart = false;
  double interval = 5;
  String run;
  List<dynamic>? args;
  Map<String, dynamic>? kwargs;
  String? onError;

  Cycle(this.id, this.run);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'auto_start': autoStart,
      'interval': interval,
      'run': run,
      'args': ?args,
      'kwargs': ?kwargs,
      'on_error': ?onError,
    };
  }

  void loadFromMap(Map<String, dynamic> map) {
    id = map['id'] as String? ?? '';
    autoStart = map['auto_start'] as bool? ?? false;
    interval = map['interval'] as double? ?? 0;
    run = map['run'] as String? ?? '';
    args = (map['args'] as List?);
    kwargs = (map['kwargs'] as Map?)?.cast();
    onError = map['on_error'] as String? ?? '';
  }
}
