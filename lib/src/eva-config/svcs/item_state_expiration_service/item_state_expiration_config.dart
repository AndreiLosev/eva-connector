import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';
import 'package:eva_connector/src/eva-config/svcs/item_state_expiration_service/expire_item.dart';

class ItemStateExpirationConfig extends ISvcConfig {
  num interval = 1;
  List<ExpireItem> items = [];

  @override
  Map<String, dynamic> toMap() {
    return {
      'interval': interval,
      'items': items.map((e) => e.toConfig()).toList(),
    };
  }

  @override
  void loadFromMap(Map map) {
    interval = (map['interval'] as num?) ?? interval;
    items =
        (map['items'] as List<dynamic>?)
            ?.whereType<String>()
            .map((e) => ExpireItem('', 0)..loadFromString((e)))
            .toList() ??
        [];
  }
}
