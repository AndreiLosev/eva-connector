import 'package:eva_connector/src/eva-config/serializable.dart';

class Action implements Serializable {
  String svc;
  double? timeout;
  Object? config;

  Action(this.svc);

  @override
  Map<String, dynamic> toMap() {
    return Map.fromEntries(
      [
        MapEntry("svc", svc),
        MapEntry("timeout", timeout),
        MapEntry("config", config),
      ].where((e) => e.value != null),
    );
  }

  @override
  void loadFromMap(Map map) {
    svc = map['svc'];
    timeout = map['timeout'];
    config = map['config'];
  }
}
