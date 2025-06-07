import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/hmi_service/hmi_config.dart';

class HmiService extends BaseSvc<HmiConfig> {
  static const svcCommand = "svc/eva-hmi";
  HmiService(String id) : super(id, svcCommand, HmiConfig());
}

