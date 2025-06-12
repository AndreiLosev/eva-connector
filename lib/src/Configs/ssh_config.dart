class SshConfig {
  String user = 'root';
  String host = '192.168.1.16';
  int port = 22;
  String keyPath = 'id_rsa';
  int localPort = 10001;
  String remoteSoket = '/opt/eva4/var/bus.ipc';

  SshConfig();

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'host': host,
      'port': port,
      'key_path': keyPath,
      'local_port': localPort,
      'remote_socket': remoteSoket,
    };
  }

  factory SshConfig.fromMap(Map map) {
    return SshConfig()
      ..user = map['user']
      ..host = map['host']
      ..port = map['port']
      ..keyPath = map['key_path']
      ..localPort = map['local_port']
      ..remoteSoket = map['remote_socket'];
  }
}
