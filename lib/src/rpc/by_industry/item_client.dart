import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/exceptions/invalid_entity.dart';
import 'package:eva_connector/src/rpc/can_do_configuration.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:eva_connector/src/rpc/responses/item_response.dart';

mixin ItemClient on CanDoRpc, CanDoConfiguration {
  Future<List<ItemResponse>> getItemState(String oidPattern) async {
    final rpcRes = await coreCall('item.state', {'i': oidPattern});
    return (rpcRes as List).map(ItemResponse.fromMap).toList();
  }

  Future<List<ItemResponseItem>> getItmesList(String oidPattern) async {
    final rpcRes = await coreCall('item.list', {'i': oidPattern});
    return (rpcRes as List).map(ItemResponseItem.fromMap).toList();
  }

  Future<Item> getItemConfig(String oid) async {
    InvalidOid.checkOid(oid);
    final rpcRes = await coreCall('item.get_config', {'i': oid});

    return factory.makeItem(rpcRes);
  }

  Future<void> itemDeploy(List<Item> items) async {
    await coreCall0('item.deploy', items.map((e) => e.toMap()));
  }

  Future<Map> action(String oid, Object value) async {
    if (factory.makeItem({'oid': oid}) is! Unit) {
      throw InvalidOid('support only Unit: $oid');
    }
    return await coreCall('action', {'i': oid, 'value': value, 'wait': 5});
  }

  Future<Map> actionToggle(String oid) async {
    if (factory.makeItem({'oid': oid}) is! Unit) {
      throw InvalidOid('support only Unit: $oid');
    }
    return await coreCall('action', {'i': oid, 'wait': 5});
  }

  Future<void> itemDestroy(String oid) async {
    await coreCall('item.destroy', {'i': oid});
  }

  Future<void> lvarSet(String oid, {int? status, Object? value}) async {
    if (factory.makeItem({'oid': oid}) is! Lvar) {
      throw InvalidOid('support only Lvar: $oid');
    }
    return switch ((status, value)) {
      (int(), Object()) => await coreCall0('lvar.set', {
        'i': oid,
        'status': status,
        'value': value,
      }),
      (Null(), Object()) => await coreCall0('lvar.set', {
        'i': oid,
        'value': value,
      }),
      (int(), Null()) => await coreCall0('lvar.set', {
        'i': oid,
        'status': status,
      }),
      (Null(), Null()) => await coreCall0('lvar.set'),
    };
  }

  Future<Map> run(
    String oid, {
    List args = const [],
    Map<String, dynamic> kwargs = const {},
  }) async {
    if (factory.makeItem({'oid': oid}) is! Lmacro) {
      throw InvalidOid('support only Lmacro: $oid');
    }
    return await coreCall('run', {
      'i': oid,
      'args': args,
      'kwargs': kwargs,
      'wait': 5,
    });
  }
}
