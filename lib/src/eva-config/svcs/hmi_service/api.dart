import 'package:eva_connector/src/eva-config/serializable.dart';

class Api implements Serializable {
  String proto = 'http';
  String listen = '0.0.0.0:7727';
  String? realIpHeader;

  Api();

  @override
  Map<String, dynamic> toMap() {
    return {
      'proto': proto,
      'listen': listen,
      if (realIpHeader != null) 'real_ip_header': realIpHeader,
    };
  }

  @override
  void loadFromMap(Map map) {
    proto = map['proto'] as String;
    listen = map['listen'] as String;
    realIpHeader = map['real_ip_header'] as String?;
  }
}
