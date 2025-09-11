import 'dart:io';

import 'package:eva_connector/eva_connector.dart';

void main(List<String> args) async {
  final config = Config();
  config.evaSoket = '192.168.1.47:10001';
  final client = RpcClient.short(config);
  await client.connect();

  final x = await client.sh('ln -s /opt/eva4/ui /opt/eva4/runtime/ui');
  final x = await client.sh('ls runtime/ui1');
  print([x.out, x.err, x.exitcode]);
  // await client.filePut(
  //   'xc/ui-accents/t1.php',
  //   (await File('/home/andrei/pictures/DX3S-2.jpg').readAsBytes()).toList(),
  // );
  // print((await client.fileGet('new-file.txt', FileGetMode.t)).text);
  // await client.fileUnlink('new-file.txt');

  await client.disconnect();
}
