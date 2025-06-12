import 'dart:io';

import 'package:eva_connector/src/Configs/ssh_config.dart';

class Config {
  String ideName = 'sofkip.ide.${Platform.environment['USER']}';
  String evaSoket = "raspberrypi.local:10001";
  var ssh = SshConfig();

  Config();

  Map<String, dynamic> toMap() {
    return {'ide_name': ideName, 'eva_soket': evaSoket, 'ssh': ssh.toMap()};
  }

  factory Config.froMap(Map map) {
    final c = Config()
      ..ideName = map['ide_name']
      ..evaSoket = map['eva_soket'];

    if (map['ssh'] != null) {
      c.ssh = SshConfig.fromMap(map['ssh']);
    }

    return c;
  }
}
