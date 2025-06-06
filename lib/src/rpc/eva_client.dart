import 'dart:typed_data';

import 'package:busrt_client/busrt_client.dart';
import 'package:eva_connector/src/eva-config/factory.dart';
import 'package:eva_connector/src/rpc/by_industry/item_client.dart';
import 'package:eva_connector/src/rpc/by_industry/svc_client.dart';
import 'package:eva_connector/src/rpc/can_do_configuration.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';

class RpcClient extends _BaseClient with ItemClient, SvcClient {
  RpcClient(super._rpc, super._factory);
}

class _BaseClient implements CanDoRpc, CanDoConfiguration {
  final Rpc _rpc;
  final Factory _factory;

  @override
  Factory get factory => _factory;

  _BaseClient(this._rpc, this._factory);

  @override
  Future<RpcOpResult> rpcCall(
    String target,
    String method, {
    Uint8List? params,
  }) => _rpc.call(target, method, params: params);

  @override
  Future<OpResult> rpcCall0(
    String target,
    String method, {
    Uint8List? params,
  }) => _rpc.call0(target, method, params: params);
}
