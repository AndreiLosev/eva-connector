class ItemResponse {
  final String oid;
  final bool connected;
  final (int, int) ieid;
  final String node;
  final int status;
  final double t;
  final dynamic value;

  ItemResponse(
    this.oid,
    this.connected,
    this.ieid,
    this.node,
    this.status,
    this.value,
    this.t,
  );

  factory ItemResponse.fromMap(dynamic map) {
    return ItemResponse(
      map['oid'],
      map['connected'],
      (map['ieid'][0], map['ieid'][1]),
      map['node'],
      map['status'],
      map['value'],
      map['t'],
    );
  }

  @override
  String toString() {
    return {
      'oid': oid,
      'connected': connected,
      'ieid': ieid,
      'node': node,
      'status': status,
      'value': value,
      't': t,
    }.toString();
  }
}
