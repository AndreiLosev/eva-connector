import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class PyMacrosConfig extends ISvcConfig {
  String? lockerSvc;
  String? mailerSvc;
  String macroDir = 'xc/py';
  Map<String, Object?> cvars = {};

  @override
  void loadFromMap(Map map) {
    lockerSvc = map['lockerSvc'];
    mailerSvc = map['mailerSvc'];
    macroDir = map['macroDir'] ?? macroDir;
    cvars = Map<String, Object?>.from(map['cvars'] ?? {});
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'lockerSvc': lockerSvc,
      'mailerSvc': mailerSvc,
      'macroDir': macroDir,
      'cvars': cvars,
    };
  }
}
