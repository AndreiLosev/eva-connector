import 'package:eva_connector/src/eva-config/serializable.dart';

class UpdatePipe implements Serializable {
  String command;
  String process;

  UpdatePipe(this.command, this.process);

  @override
  Map<String, dynamic> toMap() {
    return {'command': command, 'process': process};
  }

  @override
  void loadFromMap(Map map) {
    command = map['command'] as String;
    process = map['process'] as String;
  }
}
