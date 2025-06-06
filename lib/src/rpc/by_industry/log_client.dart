import 'package:eva_connector/src/rpc/can_do_rpc.dart';

mixin LogClient on CanDoRpc {
  Future<Map> logGet([int level = 0, limit = 10, String mes = '']) async {
    return await coreCall("log.get", {
      'level': level,
      'limit': limit,
      'mes': mes,
    });
  }

  Future<void> logPurge() async {
    return await coreCall0('log.purge');
  }
}
