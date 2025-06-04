import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/exceptions/oid_is_empty_exeption.dart';

class Action implements Serializable {
  String svc = '';
  double? timeout;
  Object? config;

  @override
  Map<String, dynamic> toMap() {
    if (svc.isEmpty) {
      throw OidIsEmptyExeption();
    }

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
