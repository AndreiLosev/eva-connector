import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/eva-config/factory.dart';
import 'package:eva_connector/src/rpc/responses/item_response.dart';

extension EvaTimeStampToDateTime on double {
  DateTime toDateTime() =>
      DateTime.fromMillisecondsSinceEpoch((this * 1000).toInt());
}

class ItemState {
  final Item oid;
  final int status;
  final dynamic value;
  final DateTime t;
  final (int, int) ieid;

  ItemState(this.oid, this.status, this.value, this.t, this.ieid);

  factory ItemState.fromItemState(Map<String, dynamic> map) {
    final oid = Factory().makeItem(map);

    final t = (map['t'] as double).toDateTime();
    final ieid = (map['ieid'][0] as int, map['ieid'][1] as int);

    return ItemState(oid, map['status'], map['value'], t, ieid);
  }

  factory ItemState.fromFrame(String topic, Map<String, dynamic> map) {
    final oidStr = topic.split('/').skip(2).join('/').replaceFirst('/', ':');
    map['oid'] = oidStr;
    return ItemState.fromItemState(map);
  }

  factory ItemState.fromItemResponse(ItemResponse res) {
    final oid = Factory().makeItem(res.toMap());
    return ItemState(oid, res.status, res.value, res.t.toDateTime(), res.ieid);
  }

  Map<String, dynamic> toMap() => {
    'oid': oid.oid,
    'status': status,
    'value': value,
    't': t,
    'ieid': ieid,
  };
}
