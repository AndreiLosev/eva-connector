import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/mqtt_config.dart';

class MqttController extends BaseSvc<MqttConfig> {
  static const svcCommand = "svc/eva-controller-pubsub";
  MqttController(String id)
    : super(id, MqttController.svcCommand, MqttConfig());
}
