import 'package:busrt_client/busrt_client.dart';
import 'package:eva_connector/src/Configs/config.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

void main(List<String> args) async {
  final c = Config();
  final bus = Bus(c.ideName);
  await bus.connect(c.evaSoket);
  final rpc = Rpc(bus);

  final keyList = await getKeyList(rpc);
  keyList.forEach(print);
  bus.disconnect();
}

Future<List<dynamic>> getKeyList(Rpc rpc) async {
  final rpcRes = await rpc.call('eva.aaa.localauth', 'key.list');

  final frame = await rpcRes.waitCompleted();

  if (frame == null) {
    throw Exception("Failed to retrieve key list");
  }

  return deserialize(frame.payload) as List<dynamic>;
}
