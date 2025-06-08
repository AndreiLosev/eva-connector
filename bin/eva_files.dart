import 'package:busrt_client/busrt_client.dart';
import 'package:eva_connector/src/Configs/config.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

void main(List<String> args) async {
  final id = 'eva.filemgr.main';
  final config = Config();
  final bus = Bus(config.ideName);
  await bus.connect(config.evaSoket);
  final rpc = Rpc(bus);
  final r = await rpc.call(id, 'sh', params: serialize({'c': 'ls'}));
  final f = await r.waitCompleted();

  if (f == null) {
    print("not found");
    return;
  }

  print(deserialize(f.payload));

  bus.disconnect();
}
