class DisksConfig {
  bool enabled = false;
  List<String> mountPoints = [];

  DisksConfig();

  DisksConfig.fromMap(Map<String, dynamic> map) {
    enabled = map['enabled'] ?? false;

    if (map['mount_points'] is List) {
      mountPoints = (map['mount_points'] as List)
          .map((e) => e.toString())
          .toList();
    }
  }

  Map<String, dynamic> toMap() => {
    'enabled': enabled,
    'mount_points': mountPoints,
  };
}
