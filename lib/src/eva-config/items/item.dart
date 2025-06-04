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
  void loadFromMap(Map map) {
    enabled = map['enabled'];
    oid = map['oid'];
  }
}

class Sensor extends Item {
  static const name = 'sensor';
  Sensor(super.oid);
}

class Lvar extends Item {
  static const name = 'lvar';
  Lvar(super.oid);
}

class Unit extends Item {
  static const name = 'unit';
  Action? action;

  Unit(super.oid);

  @override
  Map<String, dynamic> toMap() {
    final res = super.toMap();
    res['action'] = action?.toMap();

    return res;
  }

  @override
  void loadFromMap(Map map) {
    super.loadFromMap(map);
    action = map['action'];
  }
}

class Lmacro extends Item {
  static const name = 'lmacro';
  Action? action;

  Lmacro(super.oid);

  @override
  Map<String, dynamic> toMap() {
    final res = super.toMap();
    res['action'] = action?.toMap();

    return res;
  }

  @override
  void loadFromMap(Map map) {
    super.loadFromMap(map);
    action = map['action'];
  }
}
