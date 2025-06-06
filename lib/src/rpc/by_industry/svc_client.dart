import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/exceptions/not_found.dart';
import 'package:eva_connector/src/rpc/can_do_configuration.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:eva_connector/src/rpc/responses/svc_response.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

mixin SvcClient on CanDoRpc, CanDoConfiguration {
  Future<BaseSvc> getSvcParam(String id) async {
    final rpcRes = await _baseCall('svc.get_params', serialize({'i': id}));

    return factory.makeSvc(id, deserialize(rpcRes.payload));
  }

  Future<List<SvcResponse>> getSvcList() async {
    final rpcRes = await _baseCall('svc.list');

    return (rpcRes as Iterable)
        .map((item) => SvcResponse.fromMap(item))
        .toList();
  }

  Future<void> svcDeploy(List<BaseSvc> svcs) async {
    await _baseCall0('svc.deploy', svcs.map((e) => e.toMap()));
  }

  Future<void> svcUndeploy(List<String> ids) async {
    await _baseCall0('svc.undeploy', ids);
  }

  Future<void> svcRestart(String id) async {
    await _baseCall0('svc.restart', {'i': id});
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
