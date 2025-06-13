import 'package:eva_connector/src/rpc/can_do_rpc.dart';

mixin LogClient on CanDoRpc {
  Future<Map> logGet({
    int limit = 100,
    int? level,
    String? msg,
    String? rx,
    int? time,
  }) async {
    final params = {
      'limit': limit,
      if (level != null) 'level': level,
      if (msg != null) 'msg': msg,
      if (rx != null) 'rx': rx,
      if (time != null) 'time': time,
    };

    return await coreCall("log.get", params);
  }

  Future<void> logPurge() async {
    return await coreCall0('log.purge');
  }
}
