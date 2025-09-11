import 'package:eva_connector/src/rpc/can_do_configuration.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:eva_connector/src/rpc/responses/auth_key_response.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

mixin LocalAuthClient on CanDoRpc, CanDoConfiguration {
  Future<AuthKeyResponse> getKey(String id) async {
    final rpcRes = await _baseCall('key.get', {'i': id});
    return AuthKeyResponse.fromMap(rpcRes);
  }

  Future _baseCall(String method, [Map? params]) async {
    final rpcRes = await rpcCall(
      'eva.aaa.localauth',
      method,
      params: serialize(params),
    );

    final frame = await rpcRes.waitCompleted();
    if (frame == null) {
      throw Exception('not found: $method');
    }

    return deserialize(frame.payload);
  }
}
