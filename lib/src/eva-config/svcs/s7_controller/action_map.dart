import 'package:eva_connector/src/eva-config/svcs/s7_controller/enums.dart';

class ActionMap {
  S7Area area = DataBlock(1);
  (int, int?) offset = (1, null);
  S7Type? type;

  ActionMap();

  static ActionMap fromMap(Map map) {
    final res = ActionMap();
    res.area = S7Area.fromString(map['area']);
    res.offset = parseOffset(map['offset']);
    res.type = S7Type.fromString(map['type']);

    return res;
  }

  Map<String, dynamic> toMap() {
    final res = {'area': area, 'offset': offset};
    if (type != null) {
      res['type'] = type!;
    }
    return res;
  }
}
