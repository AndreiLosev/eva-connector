import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/transform_function.dart';

class ExeTaskMap {
  String name = '';
  String? path;
  List<TransformFunction> transform = [];

  ExeTaskMap();

  ExeTaskMap.fromMap(Map<String, dynamic> map) {
    name = map['name'] ?? '';
    path = map['path'] as String?;

    if (map['transform'] is List) {
      transform = (map['transform'] as List)
          .map((t) => TransformFunction.fromMap(t as Map<String, dynamic>))
          .toList();
    }
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    if (path != null) 'path': path,
    'transform': transform.map((t) => t.toMap()).toList(),
  };
}
