import 'dart:io';

import 'package:eva_connector/src/Configs/ssh_config.dart';

class Config {
  final ideName = 'sofkip.ide.${Platform.environment['LOGNAME']}';
  final evaSoket = "raspberrypi.local:10001";
  final projectDir = Directory.current.path;
  final ssh = SshConfig();
}
