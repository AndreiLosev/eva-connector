import 'package:eva_connector/src/eva-config/serializable.dart';

abstract class ISvcConfig implements Serializable {
  bool empty = true;

  Map? toMapEmpty() {
    if (empty) {
      return null;
    }

    return toMap();
  }

  void loadFromMapEmpty(Map? map) {
    if (map == null) {
      empty = true;
      return;
    }

    empty = false;

    loadFromMap(map);
  }
}
