import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class SharedLockConfig extends ISvcConfig {
  List<String> locks = [];

  @override
  void loadFromMap(Map map) {
    locks = (map['locks'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
  }

  @override
  Map<String, dynamic> toMap() {
    return {'locks': locks};
  }
}

