import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/exceptions/not_found.dart';
import 'package:eva_connector/src/rpc/can_do_configuration.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:eva_connector/src/rpc/responses/svc_response.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

mixin SvcClient on CanDoRpc, CanDoConfiguration {
  Future<BaseSvc> getSvcParam(String oid) async {
    final rpcRes = await rpcCall(
      'eva.core',
      'svc.get_params',
      params: serialize({'i': oid}),
    );

    final frame = await rpcRes.waitCompleted();

    if (frame == null) {
      throw NotFoundService(oid);
    }

    return factory.makeSvc(oid, deserialize(frame.payload));
  }

  Future<List<SvcResponse>> getSvcList() async {
    final rpcRes = await rpcCall('eva.core', 'svc.list');

    final frame = await rpcRes.waitCompleted();

    if (frame == null) {
      throw NotFoundService("*");
    }

    final data = deserialize(frame.payload) as List;
    return data.map((item) => SvcResponse.fromMap(item)).toList();
  }
}
