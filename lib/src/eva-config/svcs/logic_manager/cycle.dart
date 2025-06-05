class Cycle {
  String id;
  bool autoStart = false;
  num interval = 0;
  String run;
  List<dynamic> args = [];
  Map<String, dynamic> kwargs = {};
  String onError = '';

  Cycle(this.id, this.run);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'auto_start': autoStart,
      'interval': interval,
      'run': run,
      'args': args,
      'kwargs': kwargs,
      if (onError.isNotEmpty) 'on_error': onError,
    };
  }

  void loadFromMap(Map<String, dynamic> map) {
    id = map['id'] as String? ?? '';
    autoStart = map['auto_start'] as bool? ?? false;
    interval = map['interval'] as num? ?? 0;
    run = map['run'] as String? ?? '';
    args = map['args'] as List<dynamic>? ?? [];
    kwargs = map['kwargs'] as Map<String, dynamic>? ?? {};
    onError = map['on_error'] as String? ?? '';
  }
}
