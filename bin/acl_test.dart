import 'package:eva_connector/src/Configs/config.dart';
import 'package:eva_connector/src/rpc/eva_client.dart';

void main(List<String> args) async {
  final c = Config();
  final rpc = RpcClient.short(c);
  await rpc.connect();
  final r = await rpc.getKey('admin');

  print([r.id, r.key]);

  await rpc.disconnect();
}
