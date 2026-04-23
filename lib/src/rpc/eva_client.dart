import 'dart:async';
import 'dart:typed_data';

import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/eva-config/factory.dart';
import 'package:eva_connector/src/rpc/by_industry/file_client.dart';
import 'package:eva_connector/src/rpc/by_industry/item_client.dart';
import 'package:eva_connector/src/rpc/by_industry/local_auth_client.dart';
import 'package:eva_connector/src/rpc/by_industry/log_client.dart';
import 'package:eva_connector/src/rpc/by_industry/actions.dart';
import 'package:eva_connector/src/rpc/by_industry/svc_client.dart';
import 'package:eva_connector/src/rpc/can_do_configuration.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:msgpack_dart/msgpack_dart.dart';
import 'package:busrt_client/busrt_client.dart' as busrt;

export 'package:eva_connector/src/rpc/by_industry/enums.dart';
export 'package:eva_connector/src/rpc/responses/test_response.dart';
export 'package:eva_connector/src/rpc/responses/log_response_item.dart';
export 'package:eva_connector/src/rpc/responses/file_list_item_response.dart';
export 'package:eva_connector/src/rpc/responses/file_sh_response.dart';
export 'package:eva_connector/src/rpc/responses/auth_key_response.dart';
export 'package:eva_connector/src/rpc/responses/action_result.dart';

class RpcClient extends _BaseClient
    with
        ItemClient,
        SvcClient,
        LogClient,
        FileClient,
        LocalAuthClient,
        Actions {
  final Config config;

  RpcClient(super._rpc, super._factory, this.config);

  RpcClient.short(this.config)
    : super(busrt.Rpc(busrt.Bus(config.ideName)), Factory());

  Future<void> connect() => _rpc.bus.connect(config.evaSoket);

  Future<void> disconnect() => _rpc.bus.disconnect();
}

class _BaseClient implements CanDoRpc, CanDoConfiguration {
  final busrt.Rpc _rpc;
  final Factory _factory;

  final _subscribers = <String, FutureOr<void> Function(busrt.Frame f)>{};

  @override
  Factory get factory => _factory;

  _BaseClient(this._rpc, this._factory) {
    _rpc.onFrame = _onFraneHandler;
  }

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

  Future<void> subscribe(
    String topic,
    FutureOr<void> Function(busrt.Frame f) fn,
  ) async {
    _subscribers[topic] = fn;
    await _rpc.bus.subscribe([topic]);
  }

  Future<void> subscribeForItem(
    Item item,
    void Function(ItemState state) update,
  ) async {
    await subscribe(item.topic, (busrt.Frame f) {
      update(
        ItemState.fromFrame(f.topic!, (deserialize(f.payload) as Map).cast()),
      );
    });
  }

  Future<void> unsubscribe(String topic) async {
    _subscribers.remove(topic);
    await _rpc.bus.unsubscribe([topic]);
  }

  Future<void> unsubscribeForItem(Item item) async {
    await unsubscribe(item.topic);
  }

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

  void _onFraneHandler(busrt.Frame f) {
    if (f.topic == null) return;
    final fn = _subscribers[f.topic!];
    if (fn == null) return;
    fn(f);
  }
}
