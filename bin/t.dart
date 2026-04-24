import 'dart:convert';

import 'package:eva_connector/eva_connector.dart';

void main(List<String> args) async {
  final c = Config();
  c.evaSoket = "localhost:10001";
  c.ideName = 'test.wasa.losev';
  final client = RpcClient.short(c);

  await client.connect();

  final res = await client.run(
    'lmacro:for_py_macro/my_macro-3',
    args: [11, 12, 13],
    kwargs: {"1": 33, "2": 22},
  );

  final x = JsonEncoder.withIndent('  ');
  print(x.convert(res.toMap()));

  await client.disconnect();
}
