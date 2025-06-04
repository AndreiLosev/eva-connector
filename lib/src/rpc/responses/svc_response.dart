class SvcResponse {
  final String id;
  final String launcher;
  final int pid;
  final String status;

  SvcResponse(this.id, this.launcher, this.pid, this.status);

  factory SvcResponse.fromMap(Map map) {
    return SvcResponse(map['id'], map['launcher'], map['pid'], map['status']);
  }
}
