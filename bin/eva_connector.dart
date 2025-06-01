import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:busrt_client/busrt_client.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:eva_connector/src/config.dart';
import 'package:eva_connector/src/rpc/eva_client.dart';
import 'package:eva_connector/src/ssh/client.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

void main(List<String> arguments) async {
  await busRt();
}

Future<void> ssh() async {
  final sshSocket = await SSHSocket.connect('192.168.1.16', 22);
  final client = SSHClient(
    sshSocket,
    username: 'root',
    onPasswordRequest: () => '123',
  );
  await client.authenticated;
  final res = await client.run("ls /home/admin1/ -a");

  print(utf8.decode(res));
  client.close();
}

Future<void> busRt() async {
  final bus = Bus("softkip.eva.ide");
  final rpc = Rpc(bus);
  await rpc.bus.connect('127.0.0.1:10001');
  final c = EvaClient(rpc);

  //final x = await c.getItemState("*");
  //x.forEach(print);
  //await c.getItemConfig('unit:tank2/pump');
  await c.getSvcParam('eva.controller.modbus1');
  bus.disconnect();
}
