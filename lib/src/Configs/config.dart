import 'dart:io';

import 'package:eva_connector/src/Configs/ssh_config.dart';

class Config {
  String ideName = 'sofkip.ide.${Platform.environment['USER']}';
  String evaSoket = "raspberrypi.local:10001";
  String projectDir = Directory.current.path;
  final ssh = SshConfig();
}
