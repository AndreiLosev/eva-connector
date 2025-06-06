import 'dart:typed_data';

import 'package:busrt_client/busrt_client.dart';

abstract interface class CanDoRpc {
  Future<RpcOpResult> rpcCall(
    String target,
    String method, {
    Uint8List? params,
  });

  Future<OpResult> rpcCall0(String target, String method, {Uint8List? params});

  Future coreCall(String method, [Object? params]);

  Future coreCall0(String method, [Object? params]);
}
