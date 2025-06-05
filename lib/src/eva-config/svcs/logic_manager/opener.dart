class Opener {
  String oid;
  bool breakOnStatusError = true;
  Logic logic = Logic.ac;
  List<String> port = [];
  List<String> dport = [];
  num portTimeout = 2;
  bool setState = true;
  List<num> steps = [];
  num tuning = 0.2;
  num warmupClose = 0.5;
  num warmupOpen = 1;
  int ts = 1;
  int te = 2;

  Opener(this.oid);

  Map<String, dynamic> toMap() {
    return {
      'oid': oid,
      'break_on_status_error': breakOnStatusError,
      'logic': logic.name,
      'port': port,
      'dport': dport,
      'port_timeout': portTimeout,
      'set_state': setState,
      if (steps.isNotEmpty) 'steps': steps,
      'tuning': tuning,
      'warmup_close': warmupClose,
      'warmup_open': warmupOpen,
      'ts': ts,
      'te': te,
    };
  }

  void loadFromMap(Map<String, dynamic> map) {
    oid = map['oid'];
    breakOnStatusError = map['break_on_status_error'];
    logic = Logic.fromString(map['logic']);
    port = map['port'];
    dport = map['dport'];
    portTimeout = map['port_timeout'];
    setState = map['set_state'];
    steps = map['steps'];
    tuning = map['tuning'];
    warmupClose = map['warmup_close'];
    warmupOpen = map['warmup_open'];
    ts = map['ts'];
    te = map['te'];
  }
}

enum Logic {
  ac,
  rdc;

  static Logic fromString(String str) {
    return switch (str) {
      'ac' => Logic.ac,
      'rdc' => Logic.rdc,
      _ => throw Exception("invalid ligic: $str"),
    };
  }
}
