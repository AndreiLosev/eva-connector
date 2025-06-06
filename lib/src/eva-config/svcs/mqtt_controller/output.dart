import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/output_map.dart';

class Output implements Serializable {
  String topic = 'test/test';
  int? qos;
  Process packer = Process.value;
  int? interval;
  bool? ignoreEvents;
  List<OutputMap> map = [];

  Output();

  @override
  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'qos': qos,
      'packer': packer,
      'interval': interval,
      'ignore_events': ignoreEvents,
      'map': map.map((e) => e.toMap()).toList(),
    };
  }

  @override
  void loadFromMap(Map map) {
    topic = map['topic'] ?? '';
    qos = map['qos'];
    packer = map['packer'];
    interval = map['interval'];
    ignoreEvents = map['ignore_events'];
    this.map =
        (map['map'] as List?)
            ?.map((e) => OutputMap(e['oid'])..loadFromMap(e))
            .toList() ??
        [];
  }
}
