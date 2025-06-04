class SshConfig {
  String user = 'root';
  String host = '192.168.1.16';
  int port = 22;
  String keyPath = 'id_rsa';
  int localPort = 10001;
  String remoteSoket = '/opt/eva4/var/bus.ipc';
}
