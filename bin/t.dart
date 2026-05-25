import 'dart:convert';

import 'package:eva_connector/eva_connector.dart';

void main(List<String> args) async {
  final c = Config();
  c.evaSoket = "localhost:10001";
  c.ideName = 'test.wasa.losev';
  final client = RpcClient.short(c);

  await client.connect();

  final res = await client.sh('ls sbin/cloud-deploy.sh');

  print(res.out.contains('cloud-deploy.sh'));

  await client.disconnect();
}
