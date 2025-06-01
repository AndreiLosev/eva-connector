import 'dart:convert';

import 'package:busrt_client/busrt_client.dart';
import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/rpc/responses/item_response.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

class EvaClient {
  final Rpc _rpc;

  EvaClient(this._rpc);

  Future<List<ItemResponse>> getItemState(String oidPattern) async {
    final rpcRes = await _rpc.call(
      'eva.core',
      'item.state',
      params: serialize({'i': oidPattern}),
    );

    final frame = await rpcRes.waitCompleted();

    final result = <ItemResponse>[];

    return (deserialize(frame!.payload) as List)
        .map(ItemResponse.fromMap)
        .toList();
  }

  Future<Item> getItemConfig(String oid) async {
    final rpcRes = await _rpc.call(
      'eva.core',
      'item.get_config',
      params: serialize({'i': oid}),
    );

    print(deserialize(frame!.payload));
  }

  Future<void> getSvcParam(String oid) async {
    final rpcRes = await _rpc.call(
      'eva.core',
      'svc.get_params',
      params: serialize({'i': oid}),
    );

    final frame = await rpcRes.waitCompleted();
    print(jsonEncode(deserialize(frame!.payload)));
  }
}
