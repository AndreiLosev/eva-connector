import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';
import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/api_config.dart';
import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/report_config.dart';

class SystemMonitoringConfig extends ISvcConfig {
  ApiConfig api = ApiConfig();
  ReportConfig report = ReportConfig();

  @override
  Map<String, dynamic> toMap() => {
    'api': api.toMap(),
    'report': report.toMap(),
  };

  @override
  void loadFromMap(Map map) {
    api = ApiConfig.fromMap(map['api'] as Map<String, dynamic>?);
    report = ReportConfig.fromMap(map['report'] as Map<String, dynamic>);
  }
}
