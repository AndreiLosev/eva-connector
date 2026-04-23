import 'package:eva_connector/eva_connector.dart';

void main(List<String> args) async {
  final c = Config();
  c.evaSoket = "localhost:10001";
  c.ideName = 'test.wasa.losev';
  final client = RpcClient.short(c);

  await client.connect();

  final res = await client.action('unit:tank1/valve2', 0);

  print("uuid: ${res.toMap()}");

  await client.disconnect();
}
