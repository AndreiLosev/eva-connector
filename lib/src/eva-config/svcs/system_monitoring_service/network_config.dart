class NetworkConfig {
  bool enabled = false;
  List<String> interfaces = [];

  NetworkConfig();

  NetworkConfig.fromMap(Map<String, dynamic> map) {
    enabled = map['enabled'] ?? false;

    if (map['interfaces'] is List) {
      interfaces = (map['interfaces'] as List)
          .map((e) => e.toString())
          .toList();
    }
  }

  Map<String, dynamic> toMap() => {
    'enabled': enabled,
    'interfaces': interfaces,
  };
}
