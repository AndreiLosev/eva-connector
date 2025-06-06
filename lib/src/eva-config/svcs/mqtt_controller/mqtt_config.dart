import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/action_map.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/extra.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/input.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/output.dart';
import 'package:eva_connector/src/eva-config/svcs/mqtt_controller/pub_sub.dart';

class MqttConfig extends ISvcConfig {
  int inputCacheSec = 3600;
  PubSub pubsub = PubSub();
  List<Input>? input;
  List<Output>? output;
  Map<String, ActionMap>? actionMap;
  Extra? extra;

  @override
  Map<String, dynamic> toMap() {
    return {
      'input_cache_sec': inputCacheSec,
      'pubsub': pubsub.toMap(),
      if (input != null) 'input': input!.map((e) => e.toMap()).toList(),
      if (output != null) 'output': output!.map((e) => e.toMap()).toList(),
      if (actionMap != null)
        'action_map': actionMap?.map((k, v) => MapEntry(k, v.toMap())),
      if (extra != null) 'extra': extra?.toMap(),
    };
  }

  @override
  void loadFromMap(Map map) {
    inputCacheSec = map['input_cache_sec'] ?? 3600;
    pubsub = PubSub()..loadFromMap(map['pubsub'] ?? {});
    input = (map['input'] as List?)
        ?.map((e) => Input()..loadFromMap(e))
        .toList();
    output = (map['output'] as List?)
        ?.map((e) => Output()..loadFromMap(e))
        .toList();
    actionMap = (map['action_map'] as Map?)?.map(
      (k, v) => MapEntry(k.toString(), ActionMap()..loadFromMap(v)),
    );
    if (map['extra'] != null) {
      final ex = Extra();
      ex.loadFromMap(map['extra']);
      extra = ex;
    }
  }
}
