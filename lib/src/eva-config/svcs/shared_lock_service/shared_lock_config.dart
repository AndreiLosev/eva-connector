import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class SharedLockConfig extends ISvcConfig {
  List<String> locks = [];

  @override
  void loadFromMap(Map map) {
    locks = List<String>.from(map['locks'] ?? []);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'locks': locks};
  }
}

