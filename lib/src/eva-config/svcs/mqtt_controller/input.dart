import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/input_map.dart';

class MqttInput implements Serializable {
  String topic = 'test/test';
  Packer? packer = Packer.no;
  List<InputMap> map = [];

  @override
  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      if (packer != null) 'packer': packer!.name,
      'map': map.map((e) => e.toMap()).toList(),
    };
  }

  @override
  void loadFromMap(Map map) {
    topic = map['topic'] ?? '';
    packer = map['packer'] != null ? Packer.fromString(map['packer']) : Packer.no;
    this.map =
        (map['map'] as List?)
            ?.map((e) => InputMap(e['oid'])..loadFromMap(e))
            .toList() ??
        [];
  }
}
