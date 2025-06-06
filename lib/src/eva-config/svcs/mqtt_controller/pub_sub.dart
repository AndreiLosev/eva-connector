import 'package:eva_connector/src/eva-config/serializable.dart';

class PubSub implements Serializable {
  String proto = 'mqtt';
  String? caCerts;
  List<String> host = const ['127.0.0.1:1883'];
  bool clusterHostsRandomize = false;
  String? username;
  String? password;
  int pingInterval = 10;
  int queueSize = 1024;
  int qos = 1;

  @override
  Map<String, dynamic> toMap() {
    return {
      'proto': proto,
      'ca_certs': caCerts,
      'host': host,
      'cluster_hosts_randomize': clusterHostsRandomize,
      'username': username,
      'password': password,
      'ping_interval': pingInterval,
      'queue_size': queueSize,
      'qos': qos,
    };
  }

  @override
  void loadFromMap(Map map) {
    proto = map['proto'] ?? 'mqtt';
    caCerts = map['ca_certs'];
    host = map['host'];
    clusterHostsRandomize = map['cluster_hosts_randomize'];
    username = map['username'];
    password = map['password'];
    pingInterval = map['ping_interval'] ?? 10;
    queueSize = map['queue_size'] ?? 1024;
    qos = map['qos'] ?? 1;
  }
}
