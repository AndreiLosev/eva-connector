import 'dart:io';

class Config {
  final ideName = 'sofkip.ide.${Platform.environment['LOGNAME']}';
  final evaSoket = "locahost:10001";
  final evaSshPort = 22;
  final sshUser = 'root';
  final sshPassword = '123';
  final tunnelSoket = '/opt/eva4/var/bus.ipc';
  final projectPath = "${Platform.environment['HOME']}/documents/myProject";
}
