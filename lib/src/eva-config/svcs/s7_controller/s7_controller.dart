import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/s7_controller/s7_config.dart';

class S7Controller extends BaseSvc<S7Config> {
  static const svcCommand = "/opt/sofkip/svc/eva-s7-controller";

  S7Controller(String oid) : super(oid, S7Controller.svcCommand, S7Config());
}
