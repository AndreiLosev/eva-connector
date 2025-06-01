import 'package:eva_connector/src/eva-config/items/action.dart';
import 'package:eva_connector/src/eva-config/serializable.dart';
import 'package:eva_connector/src/exceptions/oid_is_empty_exeption.dart';

sealed class Item implements Serializable {
  bool enabled = true;
  String oid;

  Item(this.oid);

  @override
  Map<String, dynamic> toMap() {
    if (oid.isEmpty) {
      throw OidIsEmptyExeption();
    }

    return {"enabled": enabled, "oid": oid};
  }

  @override
  void loadFromMap(Map<String, dynamic> map) {
    enabled = map['enabled'];
    oid = map['oid'];
  }
}

class Sensor extends Item {}

class Lvar extends Item {}

class Unit extends Item {
  Action? action;

  @override
  Map<String, dynamic> toMap() {
    final res = super.toMap();
    res['action'] = action?.toMap();

    return res;
  }

  @override
  void loadFromMap(Map<String, dynamic> map) {
    super.loadFromMap(map);
    action = map['action'];
  }
}

class Lmacro extends Item {
  Action? action;

  @override
  Map<String, dynamic> toMap() {
    final res = super.toMap();
    res['action'] = action?.toMap();

    return res;
  }

  @override
  void loadFromMap(Map<String, dynamic> map) {
    super.loadFromMap(map);
    action = map['action'];
  }
}
