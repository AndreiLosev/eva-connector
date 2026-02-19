import 'package:eva_connector/eva_connector.dart';

class PyMacrosConfig extends ISvcConfig {
  String? lockerSvc;
  String? mailerSvc;
  String? alarmSvc;
  String macroDir = 'xc/py';
  Map<String, Object?> cvars = {};

  @override
  void loadFromMap(Map map) {
    lockerSvc = map['locker_svc'];
    mailerSvc = map['mailer_svc'];
    alarmSvc = map['alarm_svc'];
    macroDir = map['macro_dir'] ?? macroDir;
    cvars = Map<String, Object?>.from(map['cvars'] ?? {});
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (lockerSvc != null) 'locker_svc': lockerSvc,
      if (mailerSvc != null) 'mailer_svc': mailerSvc,
      if (alarmSvc != null) 'alarm_svc': alarmSvc,
      'macro_dir': macroDir,
      'cvars': cvars,
    };
  }
}
