import 'package:eva_connector/eva_connector.dart';

class ItemHandler {
  Item makeItem(Map map) {
    final oid = map['oid'];
    if (oid is! String) {
      throw Exception("is not item: $oid");
    }

    final result = switch (oid.split(":").first) {
      Sensor.name => Sensor(oid),
      Unit.name => Unit(oid),
      Lvar.name => Lvar(oid),
      Lmacro.name => Lmacro(oid),
      _ => throw Exception("is not item: $oid"),
    };

    result.loadFromMap(map);
    return result;
  }

  Future<List<Item>> pull(RpcClient client, String oidPattern) async {
    final items = await client.getItmesList(oidPattern);
    final oids = items.map((e) => e.oid).toList();
    final itemConfigs = <Item>[];
    for (var oid in oids) {
      final itemConfig = await client.getItemConfig(oid);
      itemConfigs.add(itemConfig);
    }

    return itemConfigs;
  }

  List<Map<String, dynamic>> toConfig(List<Item> items) {
    return items.map((e) => e.toMap()).toList();
  }

  List<Item> parse(Map map) {
    return (map['content'][0]['items'] as List)
        .map((e) => makeItem(e))
        .toList();
  }
}
