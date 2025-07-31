import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/rpc/by_industry/file_client.dart';

void main(List<String> args) async {
  final config = Config();
  config.evaSoket = '192.168.1.47:10001';
  final client = RpcClient.short(config);
  await client.connect();

  await client.filePut('new-file.txt', "wasa + 1");
  print((await client.fileGet('new-file.txt', FileGetMode.t)).text);
  await client.fileUnlink('new-file.txt');

  await client.disconnect();
}
