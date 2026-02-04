import 'package:eva_connector/src/eva-config/serializable.dart';

class Extra implements Serializable {
  List<String> topics = [];
  String process = 'lmacro:process';

  @override
  Map<String, dynamic> toMap() {
    return {'topics': topics, 'process': process};
  }

  @override
  void loadFromMap(Map map) {
    topics = (map['topics'] as List?)?.map((e) => e.toString()).toList() ?? [];
    process = map['process'] ?? 'lmacro:process';
  }
}
