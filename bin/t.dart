import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/utils/item_state.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

void main(List<String> args) async {
  final c = Config();
  c.evaSoket = "localhost:10001";
  final client = RpcClient.short(c);

  await client.connect();

  client.subscribeForItem(Lvar('lvar:cex1/test2'), (f) {
    print(f.toMap());
  });
}

Future test1(RpcClient client) async {
  final rr = await client.rpcCall('eva.aaa.localauth', 'key.list');
  final rr2 = await rr.waitCompleted();
  return deserialize(rr2!.payload);
}
