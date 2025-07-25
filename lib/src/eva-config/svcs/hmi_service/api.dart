import 'package:eva_connector/src/eva-config/serializable.dart';

class Api implements Serializable {
  String proto = 'http';
  String listen = '0.0.0.0:7727';
  String? realIpHeader;
  String? db;
  String? apiFilter;

  Api();

  @override
  Map<String, dynamic> toMap() {
    return {
      'proto': proto,
      'listen': listen,
      if (realIpHeader != null) 'real_ip_header': realIpHeader,
      if (db != null) 'db': db,
      if (apiFilter != null) 'api_filter': apiFilter,
    };
  }

  @override
  void loadFromMap(Map map) {
    proto = map['proto'];
    listen = map['listen'];
    realIpHeader = map['real_ip_header'];
    db = map['db'];
    apiFilter = map['api_filter'];
  }
}
