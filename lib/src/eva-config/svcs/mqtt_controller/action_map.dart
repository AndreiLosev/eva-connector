import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/action_map_item.dart';

class MqttActionMap implements Serializable {
  String topic = 'test/test';
  int? qos;
  List<MqttActionMapItem> map = [];

  MqttActionMap();

  @override
  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'qos': qos,
      'map': map.map((e) => e.toMap()).toList(),
    };
  }

  @override
  void loadFromMap(Map map) {
    topic = map['topic'] ?? '';
    qos = map['qos'];
    this.map =
        (map['map'] as List?)
            ?.map((e) => MqttActionMapItem()..loadFromMap(e))
            .toList() ??
        [];
  }
}
