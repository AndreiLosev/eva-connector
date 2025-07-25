import 'package:eva_connector/src/eva-config/items/action.dart';
import 'package:eva_connector/src/eva-config/serializable.dart';

sealed class Item implements Serializable {
  bool enabled = true;
  String oid;

  Item(this.oid);

  @override
  Map<String, dynamic> toMap() {
    return {"enabled": enabled, "oid": oid};
  }

  @override
  void loadFromMap(Map map) {
    enabled = map['enabled'] ?? false;
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

class Unit extends Item with MakeAction {
  static const name = 'unit';
  Action? action;

  Unit(super.oid);

  @override
  Map<String, dynamic> toMap() {
    final res = super.toMap();
    if (action != null) {
      res['action'] = action?.toMap();
    }

    return res;
  }

  @override
  void loadFromMap(Map map) {
    super.loadFromMap(map);
    if (map['action'] == null) {
      return;
    }
    action = makeAction(map['action']);
  }
}

class Lmacro extends Unit with MakeAction {
  static const name = 'lmacro';
  Lmacro(super.oid);
}

mixin MakeAction {
  Action? makeAction(Map? map) {
    if (map == null || map['svc'] is! String) {
      return null;
    }

    final a = Action(map['svc']);
    a.loadFromMap(map);
    return a;
  }
}
