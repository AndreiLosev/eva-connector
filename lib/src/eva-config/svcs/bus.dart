import 'package:eva_connector/src/eva-config/serializable.dart';

class Bus implements Serializable {
  int bufSize = 8192;
  int bufTtl = 10;
  String path = 'var/bus.ipc';
  int queueSize = 8192;
  double? timout;
  String type = 'native';

  @override
  Map<String, dynamic> toMap() {
    return {
      'buf_size': bufSize,
      'buf_ttl': bufTtl,
      'path': path,
      'queue_size': queueSize,
      'timout': timout,
      'type': type,
    };
  }

  @override
  void loadFromMap(Map map) {
    bufSize = map['buf_size'];
    bufTtl = map['buf_ttl'];
    path = map['path'];
    queueSize = map['queue_size'];
    timout = map['timout'];
    type = map['type'];
  }
}
