class AuthKeyResponse {
  final String id;
  final String key;

  AuthKeyResponse(this.id, this.key);

  factory AuthKeyResponse.fromMap(Map map) {
    return AuthKeyResponse(map['id'], map['key']);
  }
}
