import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/rpc/can_do_configuration.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:eva_connector/src/rpc/responses/svc_response.dart';

mixin SvcClient on CanDoRpc, CanDoConfiguration {
  Future<BaseSvc> getSvcParam(String id) async {
    final rpcRes = await coreCall('svc.get_params', {'i': id});

    return factory.makeSvc(id, rpcRes);
  }

  Future<List<SvcResponse>> getSvcList() async {
    final rpcRes = await coreCall('svc.list');

    return (rpcRes as Iterable)
        .map((item) => SvcResponse.fromMap(item))
        .toList();
  }

  Future<void> svcDeploy(List<BaseSvc> svcs) async {
    await coreCall0('svc.deploy', svcs.map((e) => e.toMap()));
  }

  Future<void> svcUndeploy(List<String> ids) async {
    await coreCall0('svc.undeploy', ids);
  }

  Future<void> svcRestart(String id) async {
    await coreCall0('svc.restart', {'i': id});
  }
}
