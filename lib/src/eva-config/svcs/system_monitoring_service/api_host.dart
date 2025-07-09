class ApiHost {
  String name = '';
  String key = '';

  ApiHost();

  ApiHost.fromMap(Map<String, dynamic> map) {
    name = map['name'] ?? '';
    key = map['key'] ?? '';
  }

  Map<String, dynamic> toMap() => {'name': name, 'key': key};
}
