import 'dart:convert';
import 'dart:io';

import 'package:eva_connector/src/Configs/config.dart';

void main(List<String> args) async {
  final config = Config();
  final params = [
    "-i",
    config.ssh.keyPath,
    "-L",
    "${config.evaSoket}:${config.ssh.remoteSoket}",
    "${config.ssh.user}@${config.ssh.host}",
  ];
  print("ssh ${params.join(' ')}");
  final process = await Process.start('ssh', params);
  process.stderr.listen(
    onData,
    onDone: () {
      print('end-err-end');
    },
  );

  process.stdout.listen(
    (e) {
      final m = utf8.decode(e);
      print("mes: $m");
      if (m.contains(config.ssh.host) && m.contains('password')) {
        process.kill();
      }
    },
    onDone: () {
      print('end-out-end');
    },
  );

  //process.kill();
}

void onData(List<int> e) {
  print(utf8.decode(e));
}
