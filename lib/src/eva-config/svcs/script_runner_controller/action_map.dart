import 'package:eva_connector/src/eva-config/serializable.dart';

class ActionMap implements Serializable {
  String command;
  int? timeout;
  bool updateAfter = true;

  ActionMap(this.command);

  @override
  Map<String, dynamic> toMap() {
    return {
      'command': command,
      if (timeout != null) 'timeout': timeout,
      'update_after': updateAfter,
    };
  }

  @override
  void loadFromMap(Map map) {
    command = map['command'] as String;
    timeout = map['timeout'] as int?;
    updateAfter = map['update_after'] as bool;
  }
}
