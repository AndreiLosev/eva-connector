import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class ItemStateExpirationConfig extends ISvcConfig {
  num interval = 1;
  List<String> items = [];

  @override
  Map<String, dynamic> toMap() {
    return {'interval': interval, 'items': items};
  }

  @override
  void loadFromMap(Map map) {
    interval = map['interval'];
    items = List<String>.from(map['items']);
  }
}
