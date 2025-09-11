import 'package:eva_connector/eva_connector.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

void main(List<String> args) async {
  final config = Config();
  config.evaSoket = '192.168.1.47:10001';
  final client = RpcClient.short(config);

  try {
    await client.connect();

    final rpcRes = await client.rpcCall(
      'eva.aaa.localauth',
      'key.get',
      params: serialize({'i': 'admin'}),
    );
    final res = await rpcRes.waitCompleted();
    print(deserialize(res!.payload));
  } finally {
    await client.disconnect();
  }
}

//admin api key: fiMlU91Jbz94JohtcxLFODwqKfrz5yBBUbnJJ7p9VcQVgsJr0bYFBnVwIlSF21N2
