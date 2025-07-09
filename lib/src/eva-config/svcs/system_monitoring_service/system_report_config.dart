class SystemReportConfig {
  bool enabled = false;

  SystemReportConfig();

  SystemReportConfig.fromMap(Map<String, dynamic> map) {
    enabled = map['enabled'] ?? false;
  }

  Map<String, dynamic> toMap() => {'enabled': enabled};
}
