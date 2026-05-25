import 'package:eva_connector/eva_connector.dart';

void main(List<String> arguments) async {
  final c = Config();
  c.evaSoket = "localhost:10001";
  c.ideName = 'test.wasa.losev';
  final client = RpcClient.short(c);

  await client.connect();

  client.subscribeLogs(LogLevel.info, print);
}
