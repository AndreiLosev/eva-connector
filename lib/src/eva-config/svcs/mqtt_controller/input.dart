import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/input_map.dart';

class Input implements Serializable {
  String topic = 'test/test';
  String? packer = 'no';
  List<InputMap> map = [];

  @override
  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'packer': packer,
      'map': map.map((e) => e.toMap()).toList(),
    };
  }

  @override
  void loadFromMap(Map map) {
    topic = map['topic'] ?? '';
    packer = map['packer'];
    this.map =
        (map['map'] as List?)
            ?.map((e) => InputMap(e['oid'])..loadFromMap(e))
            .toList() ??
        [];
  }
}
