import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/exceptions/invalid_entity.dart';
import 'package:eva_connector/src/exceptions/not_found.dart';
import 'package:eva_connector/src/rpc/can_do_configuration.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:eva_connector/src/rpc/responses/item_response.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

mixin ItemClient on CanDoRpc, CanDoConfiguration {
  Future<List<ItemResponse>> getItemState(String oidPattern) async {
    final rpcRes = await _baseCall('item.state', {'i': oidPattern});

    return (deserialize(rpcRes.payload) as List)
        .map(ItemResponse.fromMap)
        .toList();
  }

  Future<Item> getItemConfig(String oid) async {
    InvalidOid.checkOid(oid);
    final rpcRes = await _baseCall('item.get_config', {'i': oid});

    final frame = await rpcRes.waitCompleted();

    if (frame == null) {
      throw NotFoundItems(oid);
    }
    final data = (deserialize(frame.payload) as Map);
    return factory.makeItem(data);
  }

  Future<void> itemDeploy(List<Item> items) async {
    await _baseCall0('item.deploy', items.map((e) => e.toMap()));
  }

  Future<void> itemDestroy(String oid) async {
    await _baseCall0('item.destroy', {'i': oid});
  }

  Future _baseCall(String method, [Object? params]) async {
    final rpcRes = await rpcCall(
      'eva.core',
      method,
      params: params == null ? null : serialize(params),
    );

    final frame = await rpcRes.waitCompleted();

    return deserialize(frame!.payload);
  }

  Future _baseCall0(String method, [Object? params]) async {
    final response = await rpcCall0(
      'eva.core',
      method,
      params: params == null ? null : serialize(params),
    );

    await response.waitCompleted();
  }
}
