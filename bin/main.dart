import 'package:eva_connector/eva_connector.dart';

void main(List<String> arguments) async {
  final c = Config();
  final rpc = RpcClient.short(c);
  await rpc.connect();

  await rpc.filePut(
    './../svc/softkip-event-service123',
    'https://github.com/AndreiLosev/eva-event-service/releases/download/1.1.4/softkip-event-service',
    FilePutExtract.no,
    null,
    true,
  );

  await rpc.disconnect();
}
