class TransformFunction {
  String func = '';
  List<dynamic> params = [];

  TransformFunction();

  TransformFunction.fromMap(Map<String, dynamic> map) {
    func = map['func'] ?? '';
    if (map['params'] is Iterable) {
      params = List.from(map['params']);
    }
  }

  Map<String, dynamic> toMap() => {
    'func': func,
    'params': params,
  };
}
