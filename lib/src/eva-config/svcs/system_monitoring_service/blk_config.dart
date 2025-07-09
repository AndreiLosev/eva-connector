class BlkConfig {
  bool enabled = false;
  List<String> devices = [];

  BlkConfig();

  BlkConfig.fromMap(Map<String, dynamic> map) {
    enabled = map['enabled'] ?? false;

    if (map['devices'] is List) {
      devices = (map['devices'] as List).map((e) => e.toString()).toList();
    }
  }

  Map<String, dynamic> toMap() => {'enabled': enabled, 'devices': devices};
}
