import 'package:eva_connector/eva_connector.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

void main(List<String> args) async {
  final c = Config();
  c.evaSoket = "localhost:10001";
  final client = RpcClient.short(c);

  try {
    await client.connect();

    final [res1, res2] = await Future.wait([test1(client), test1(client)]);

    print([res1, res2]);
  } finally {
    await client.disconnect();
  }
}

Future test1(RpcClient client) async {
  final rr = await client.rpcCall('eva.aaa.localauth', 'key.list');
  final rr2 = await rr.waitCompleted();
  return deserialize(rr2!.payload);
}
