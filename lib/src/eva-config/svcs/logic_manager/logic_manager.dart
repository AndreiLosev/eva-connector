import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/logic_manager/logic_manager_config.dart';

class LogicManager extends BaseSvc<LogicManagerConfig> {
  static const svcCommand = 'svc/eva-controller-lm';
  LogicManager(String oid)
    : super(oid, LogicManager.svcCommand, LogicManagerConfig());
}
