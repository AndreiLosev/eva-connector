class SvcResponse {
  final String id;
  final String launcher;
  final String pid;
  final String status;

  SvcResponse(this.id, this.launcher, this.pid, this.status);

  factory SvcResponse.fromMap(Map<String, dynamic> map) {
    return SvcResponse(
      map['id'] as String,
      map['launcher'] as String,
      map['pid'] as String,
      map['status'] as String,
    );
  }
}

