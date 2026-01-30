import 'package:eva_connector/src/eva-config/serializable.dart';

class Extra implements Serializable {
  List<String> topics = [];
  String process = 'lmacro:process';
  String? user;
  bool? reactToFail;

  @override
  Map<String, dynamic> toMap() {
    return {
      'topics': topics,
      'process': process,
      if (user != null) 'user': user,
      if (reactToFail != null) 'react_to_fail': reactToFail,
    };
  }

  @override
  void loadFromMap(Map map) {
    topics = (map['topics'] as List?)?.map((e) => e.toString()).toList() ?? [];
    process = map['process'] ?? 'lmacro:process';
    user = map['user'];
    reactToFail = map['react_to_fail'];
  }
}
