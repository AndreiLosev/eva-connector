import 'package:eva_connector/eva_connector.dart';
import 'package:busrt_client/busrt_client.dart' as busrt;
import 'package:eva_connector/src/eva-config/factory.dart';

void main(List<String> args) async {
  await test1();
  await test2();
}

Future<void> test1() async {
  final config = Config();
  final bus = busrt.Bus(config.ideName);
  final rpc = busrt.Rpc(bus);
  final cl = RpcClient(rpc, Factory(), config);
  await cl.connect();
  final res = await cl.test();

  print(res);

  bus.disconnect();
}

Future<void> test2() async {
  final config = Config();
  final cl = RpcClient.short(config);
  await cl.connect();
  final res = await cl.test();

  print(res);

  cl.disconnect();
}
