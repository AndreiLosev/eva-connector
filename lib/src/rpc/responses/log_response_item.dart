class LogResponseItem {
  final String dt;
  final String h;
  final int l;
  final String lvl;
  final String mod;
  final String msg;
  final double t;
  final dynamic th;

  LogResponseItem({
    required this.dt,
    required this.h,
    required this.l,
    required this.lvl,
    required this.mod,
    required this.msg,
    required this.t,
    required this.th,
  });

  factory LogResponseItem.fromMap(Map map) {
    return LogResponseItem(
      dt: map['dt'],
      h: map['h'],
      l: map['l'],
      lvl: map['lvl'],
      mod: map['mod'],
      msg: map['msg'],
      t: map['t'],
      th: map['th'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dt': dt,
      'h': h,
      'l': l,
      'lvl': lvl,
      'mod': mod,
      'msg': msg,
      't': t,
      'th': th,
    };
  }
}
