class SvcResponse {
  final String id;
  final String launcher;
  final int? pid;
  final String status;
  final bool enabled;

  SvcResponse(this.id, this.launcher, this.pid, this.status, this.enabled);

  factory SvcResponse.fromMap(Map map) {
    return SvcResponse(
      map['id'],
      map['launcher'],
      map['pid'],
      map['status'],
      map['enabled'],
    );
  }

  bool isOneline() => status == 'online';
}
