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

class ItemResponseItem {
  final bool connected;
  final bool enabled;
  final (int, int)? ieid;
  final String node;
  final String oid;
  final double? t;

  ItemResponseItem(
    this.connected,
    this.enabled,
    this.ieid,
    this.node,
    this.oid,
    this.t,
  );

  factory ItemResponseItem.fromMap(dynamic map) {
    return ItemResponseItem(
      map['connected'],
      map['enabled'],
      map['ieid'] != null ? (map['ieid'][0], map['ieid'][1]) : null,
      map['node'],
      map['oid'],
      (map['t'] as num?)?.toDouble(),
    );
  }

  @override
  String toString() {
    return {
      'connected': connected,
      'enabled': enabled,
      'ieid': ieid,
      'node': node,
      'oid': oid,
      't': t,
    }.toString();
  }
}
