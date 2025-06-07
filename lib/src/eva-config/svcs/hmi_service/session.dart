import 'package:eva_connector/src/eva-config/serializable.dart';

class Session implements Serializable {
  int timeout = 60;
  bool prolong = true;
  bool stickIp = true;
  bool allowListNeighbors = true;
  bool allowConcurrent = true;

  @override
  Map<String, dynamic> toMap() {
    return {
      'timeout': timeout,
      'prolong': prolong,
      'stick_ip': stickIp,
      'allow_list_neighbors': allowListNeighbors,
      'allow_concurrent': allowConcurrent,
    };
  }

  @override
  void loadFromMap(Map map) {
    timeout = map['timeout'] as int;
    prolong = map['prolong'] as bool;
    stickIp = map['stick_ip'] as bool;
    allowListNeighbors = map['allow_list_neighbors'] as bool;
    allowConcurrent = map['allow_concurrent'] as bool;
  }
}
