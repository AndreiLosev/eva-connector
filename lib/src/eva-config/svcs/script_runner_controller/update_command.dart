import 'package:eva_connector/src/eva-config/serializable.dart';

class UpdateCommand implements Serializable {
  String command;
  List<String> oid; // String or List<String>
  int interval = 10;
  int? timeout;

  UpdateCommand(this.command, this.oid);

  @override
  Map<String, dynamic> toMap() {
    return {
      'command': command,
      'oid': oid,
      'interval': interval,
      if (timeout != null) 'timeout': timeout,
    };
  }

  @override
  void loadFromMap(Map map) {
    command = map['command'] as String;
    oid = (map['oid'] as List).cast<String>();
    interval = map['interval'] as int;
    timeout = map['timeout'] as int?;
  }
}
