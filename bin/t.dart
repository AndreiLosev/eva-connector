import 'dart:io';

import 'package:eva_connector/eva_connector.dart';

void main(List<String> args) async {
  final c = Config();
  c.evaSoket = "localhost:10001";
  c.ideName = 'test.wasa.losev';
  final client = RpcClient.short(c);

  await client.connect();

  client.subscribe('SVC/ST/#', print);
  client.subscribeLogs(LogLevel.info, print);
}
