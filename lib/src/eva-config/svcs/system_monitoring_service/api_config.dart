import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/api_host.dart';

class ApiConfig {
  String? clientOidPrefix;
  String? listen;
  int? maxClients;
  String? realIpHeader;
  String? trustedSystemHeader;
  List<ApiHost> hosts = [];

  ApiConfig();

  ApiConfig.fromMap(Map<String, dynamic>? map) {
    if (map != null) {
      clientOidPrefix = map['client_oid_prefix'] as String?;
      listen = map['listen'] as String?;
      maxClients = map['max_clients'] as int?;
      realIpHeader = map['real_ip_header'] as String?;
      trustedSystemHeader = map['trusted_system_header'] as String?;

      if (map['hosts'] is List) {
        hosts = (map['hosts'] as List)
            .map((h) => ApiHost.fromMap(h as Map<String, dynamic>))
            .toList();
      }
    }
  }

  Map<String, dynamic> toMap() => {
    if (clientOidPrefix != null) 'client_oid_prefix': clientOidPrefix,
    if (listen != null) 'listen': listen,
    if (maxClients != null) 'max_clients': maxClients,
    if (realIpHeader != null) 'real_ip_header': realIpHeader,
    if (trustedSystemHeader != null)
      'trusted_system_header': trustedSystemHeader,
    'hosts': hosts.map((h) => h.toMap()).toList(),
  };
}
