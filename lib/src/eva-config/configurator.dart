import 'package:eva_connector/src/eva-config/factory.dart';
import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/exceptions/unsupported_service.dart';
import 'package:eva_connector/src/rpc/eva_client.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

class Configurator {
  final YamlWriter _yamlWriter;
  final Factory _factory;

  Configurator(this._yamlWriter, this._factory);

  factory Configurator.short() {
    return Configurator(YamlWriter(), Factory());
  }

  Future<void> pullAll(RpcClient client) async {
    await client.connect();
    final items = await pullItems(client, '*');
    final svcs = await pullSvcs(client);
    await client.disconnect();
    makeConfig(items, svcs);
  }

  Future<List<Item>> pullItems(RpcClient client, String oidPattern) async {
    final items = await client.getItemState(oidPattern);
    final oids = items.map((e) => e.oid).toList();
    final itemConfigs = <Item>[];
    for (var oid in oids) {
      final itemConfig = await client.getItemConfig(oid);
      itemConfigs.add(itemConfig);
    }

    return itemConfigs;
  }

  Future<List<BaseSvc>> pullSvcs(RpcClient client) async {
    final svcs = await client.getSvcList();
    final oids = svcs.map((e) => e.id).toList();
    final configs = <BaseSvc>[];
    for (var oid in oids) {
      try {
        final itemConfig = await client.getSvcParam(oid);
        configs.add(itemConfig);
      } on UnsupportedService {
        continue;
      }
    }

    return configs;
  }

  String makeConfig(List<Item> items, List<BaseSvc> svcs) {
    final map = {
      "version": 4,
      "content": [
        {
          "node": ".local",
          "items": items.map((e) => e.toMap()).toList(),
          "svcs": svcs.map((e) => e.toMap()).toList(),
        },
      ],
    };

    return _yamlWriter.write(map);
  }

  (List<Item>, List<BaseSvc>) loadConfig(String yaml) {
    final map = loadYaml(yaml);
    final items = (map['content'][0]['items'] as List)
        .map((e) => _factory.makeItem(e))
        .toList();

    final svcs = (map['content'][0]['svcs'] as List)
        .map((e) => _factory.makeSvc(e['id'], e['params']))
        .toList();

    return (items, svcs);
  }
}
