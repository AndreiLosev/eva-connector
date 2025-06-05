import 'package:eva_connector/src/eva-config/svcs/s7_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/s7_controller/offset_map.dart';

class PullConfig {
  S7Area area = DataBlock(1);
  bool singleRequest = false;
  List<OffsetMap> map = [];

  static PullConfig fromMap(Map map) {
    final res = PullConfig();
    res.area = S7Area.fromString(map['area']);
    res.singleRequest = map['single_request'];
    res.map = (map['map'] as List).map((e) => OffsetMap.fromMap(e)).toList();

    return res;
  }

  Map<String, dynamic> toMap() {
    return {
      'area': area,
      'single_request': singleRequest,
      'map': map.map((e) => e.toMap()).toList(),
    };
  }
}
