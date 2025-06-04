import 'package:busrt_client/busrt_client.dart';
import 'package:eva_connector/src/eva-config/factory.dart';
import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/rpc/responses/item_response.dart';
import 'package:eva_connector/src/rpc/responses/svc_response.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

class EvaClient {
  final Rpc _rpc;
  final Factory _factory;

  EvaClient(this._rpc, this._factory);

  Future<List<ItemResponse>> getItemState(String oidPattern) async {
    final rpcRes = await _rpc.call(
      'eva.core',
      'item.state',
      params: serialize({'i': oidPattern}),
    );

    final frame = await rpcRes.waitCompleted();

    if (frame == null) {
      throw Exception("not found items: $oidPattern");
    }

    return (deserialize(frame.payload) as List)
        .map(ItemResponse.fromMap)
        .toList();
  }

  Future<Item> getItemConfig(String oid) async {
    final rpcRes = await _rpc.call(
      'eva.core',
      'item.get_config',
      params: serialize({'i': oid}),
    );

    final frame = await rpcRes.waitCompleted();

    if (frame == null) {
      throw Exception("not found item: $oid");
    }
    final data = (deserialize(frame.payload) as Map);
    return _factory.makeItem(data);
  }

  Future<BaseSvc> getSvcParam(String oid) async {
    final rpcRes = await _rpc.call(
      'eva.core',
      'svc.get_params',
      params: serialize({'i': oid}),
    );

    final frame = await rpcRes.waitCompleted();

    if (frame == null) {
      throw Exception("Not found svc: $oid");
    }

    return _factory.makeSvc(deserialize(frame.payload));
  }

  Future<List<SvcResponse>> getSvcList() async {
    final rpcRes = await _rpc.call('eva.core', 'svc.list');

    final frame = await rpcRes.waitCompleted();

    if (frame == null) {
      throw Exception("Failed to retrieve service list");
    }

    final data = deserialize(frame.payload) as List;
    return data.map((item) => SvcResponse.fromMap(item)).toList();
  }
}
