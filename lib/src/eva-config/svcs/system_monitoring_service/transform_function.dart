class TransformFunction {
  String name = '';
  List<dynamic> params = [];

  TransformFunction();

  TransformFunction.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      name = map.keys.first;
      params = map[name] is Iterable ? List.from(map[name]) : [];
    }
  }

  Map<String, dynamic> toMap() => {name: params};
}
