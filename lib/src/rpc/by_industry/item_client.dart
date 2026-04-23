import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/rpc/can_do_configuration.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:eva_connector/src/rpc/responses/item_response.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

mixin ItemClient on CanDoRpc, CanDoConfiguration {
  Future<List<ItemState>> getItemState(String oidPattern) async {
    final rpcRes = await coreCall('item.state', {'i': oidPattern});
    return (rpcRes as List)
        .map(ItemResponse.fromMap)
        .map(ItemState.fromItemResponse)
        .toList();
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

  Future<ActionResult> action(String oid, dynamic value) async {
    if (factory.makeItem({'oid': oid}) is! Unit) {
      throw InvalidOid('support only Unit: $oid');
    }
    final map = await coreCall('action', {
      'i': oid,
      'params': {'value': value},
      'wait': 5,
      'u': Uuid.parse(UuidV4().generate()),
      'priority': 100,
    });
    return ActionResult.fromMap((map as Map).cast());
  }

  Future<Map> actionToggle(String oid) async {
    if (factory.makeItem({'oid': oid}) is! Unit) {
      throw InvalidOid('support only Unit: $oid');
    }
    return await coreCall('action.toggle', {'i': oid, 'wait': 5});
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

  Future<ActionResult> run(
    String oid, {
    List args = const [],
    Map<String, dynamic> kwargs = const {},
  }) async {
    if (factory.makeItem({'oid': oid}) is! Lmacro) {
      throw InvalidOid('support only Lmacro: $oid');
    }
    final map = await coreCall('run', {
      'i': oid,
      'params': {'args': args, 'kwargs': kwargs},
      'wait': 5,
      'u': Uuid.parse(UuidV4().generate()),
      'priority': 100,
    });

    return ActionResult.fromMap((map as Map).cast());
  }
}
