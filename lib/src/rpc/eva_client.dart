import 'dart:typed_data';

import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/eva-config/factory.dart';
import 'package:eva_connector/src/rpc/by_industry/file_client.dart';
import 'package:eva_connector/src/rpc/by_industry/item_client.dart';
import 'package:eva_connector/src/rpc/by_industry/log_client.dart';
import 'package:eva_connector/src/rpc/by_industry/svc_client.dart';
import 'package:eva_connector/src/rpc/can_do_configuration.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:msgpack_dart/msgpack_dart.dart';
import 'package:busrt_client/busrt_client.dart' as busrt;

class RpcClient extends _BaseClient
    with ItemClient, SvcClient, LogClient, FileClient {
  final Config config;

  RpcClient(super._rpc, super._factory, this.config);

  factory RpcClient.short(Config config) {
    final bus = busrt.Bus(config.ideName);
    final rpc = busrt.Rpc(bus);

    return RpcClient(rpc, Factory(), config);
  }

  Future<void> connect() => _rpc.bus.connect(config.evaSoket);

  Future<void> disconnect() => _rpc.bus.disconnect();
}

class _BaseClient implements CanDoRpc, CanDoConfiguration {
  final busrt.Rpc _rpc;
  final Factory _factory;

  @override
  Factory get factory => _factory;

  _BaseClient(this._rpc, this._factory);

  @override
  Future<busrt.RpcOpResult> rpcCall(
    String target,
    String method, {
    Uint8List? params,
  }) => _rpc.call(target, method, params: params);

  @override
  Future<busrt.OpResult> rpcCall0(
    String target,
    String method, {
    Uint8List? params,
  }) => _rpc.call0(target, method, params: params);

  @override
  Future coreCall(String method, [Object? params]) async {
    final rpcRes = await rpcCall(
      'eva.core',
      method,
      params: params == null ? null : serialize(params),
    );

    final frame = await rpcRes.waitCompleted();

    return deserialize(frame!.payload);
  }

  @override
  Future coreCall0(String method, [Object? params]) async {
    final response = await rpcCall0(
      'eva.core',
      method,
      params: params == null ? null : serialize(params),
    );

    await response.waitCompleted();
  }

  Future<TestResponse> test() async {
    final rawRes = await coreCall('test');
    return TestResponse.fromMap(rawRes);
  }
}
