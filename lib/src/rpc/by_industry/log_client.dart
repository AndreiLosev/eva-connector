import 'package:eva_connector/src/rpc/can_do_rpc.dart';
import 'package:eva_connector/src/rpc/responses/log_response_item.dart';

mixin LogClient on CanDoRpc {
  Future<List<LogResponseItem>> logGet({
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

    final rawRes = await coreCall("log.get", params);

    return (rawRes as List).map((e) => LogResponseItem.fromMap(e)).toList();
  }

  Future<void> logPurge() async {
    return await coreCall0('log.purge');
  }
}
