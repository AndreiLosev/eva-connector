import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:msgpack_dart/msgpack_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

mixin Marcos on CanDoRpc {
  Future<void> runToSvc(
    String svcId,
    Lmacro lmacro, {
    List? args,
    Map<String, dynamic>? kwargs,
  }) async {
    rpcCall0(
      'svcId',
      'run',
      params: serialize({
        'uuid': Uuid.parse(UuidV4().generate()),
        'i': lmacro.oid,
        'timeout': 10,
        'priority': 100,
        'params': {
          if (args != null) 'args': args,
          if (kwargs != null) 'kwargs': kwargs,
        },
      }),
    );
  }
}
