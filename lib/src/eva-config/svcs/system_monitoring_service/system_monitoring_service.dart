import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/system_monitoring_config.dart';

class SystemMonitoringService extends BaseSvc<SystemMonitoringConfig> {
  static const svcCommand = "svc/eva-controller-system";

  SystemMonitoringService(String id)
    : super(id, SystemMonitoringService.svcCommand, SystemMonitoringConfig());
}
