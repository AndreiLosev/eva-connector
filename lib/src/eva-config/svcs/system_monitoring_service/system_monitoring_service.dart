import 'package:eva_connector/eva_connector.dart';

class SystemMonitoringService extends BaseSvc<SystemMonitoringConfig> {
  static const svcCommand = "svc/eva-controller-system";

  SystemMonitoringService(String id)
    : super(id, SystemMonitoringService.svcCommand, SystemMonitoringConfig());
}
