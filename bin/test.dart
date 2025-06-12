import 'package:eva_connector/eva_connector.dart';
import 'package:busrt_client/busrt_client.dart' as busrt;
import 'package:eva_connector/src/eva-config/factory.dart';

void main(List<String> args) async {
  final config = Config();
  final bus = busrt.Bus(config.ideName);
  final rpc = busrt.Rpc(bus);
  final cl = RpcClient(rpc, Factory(), config);

  print('run: 1');
  //await test1();
  await test2(cl);
  await Future.delayed(Duration(seconds: 5));
  print('run: 2');
  //await test1();
  await test2(cl);
  await Future.delayed(Duration(seconds: 5));
  print('run: 3');
  //await test1();
  await test2(cl);
  await Future.delayed(Duration(seconds: 5));
  print('run: 4');
  //await test1();
  await test2(cl);
}

Future<void> test1() async {
  final config = Config();
  final bus = busrt.Bus(config.ideName);
  final rpc = busrt.Rpc(bus);
  final cl = RpcClient(rpc, Factory(), config);
  await cl.connect();
  final res = await cl.test();

  print(res);

  await bus.disconnect();
}

Future<void> test2(RpcClient cl) async {
  await cl.connect();
  final res = await cl.test();

  print(res);

  await cl.disconnect();
}
