import 'package:eva_connector/eva_connector.dart';

void main(List<String> arguments) async {
  final c = Config();
  c.evaSoket = '192.168.1.3:10001';
  final rpc = RpcClient.short(c);
  await rpc.connect();

  await rpc.filePut(
    'file-test',
    'https://github.com/AndreiLosev/eva-event-service/releases/download/1.1.5/softkip-event-service',
    FilePutExtract.no,
    null,
    true,
  );

  await rpc.disconnect();
}
