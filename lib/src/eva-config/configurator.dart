import 'dart:io';

import 'package:eva_connector/src/Configs/config.dart';
import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/exceptions/unsupported_service.dart';
import 'package:eva_connector/src/rpc/eva_client.dart';
import 'package:yaml_writer/yaml_writer.dart';

class Configurator {
  final RpcClient _client;
  final Config _config;
  final YamlWriter _yamlWriter;

  Configurator(this._client, this._config, this._yamlWriter);

  Future<void> pullAll() async {
    final items = await pullItems('*');
    final svcs = await pullSvcs();

    makeConfig(items, svcs);
  }

  Future<List<Item>> pullItems(String oidPattern) async {
    final items = await _client.getItemState(oidPattern);
    final oids = items.map((e) => e.oid).toList();
    final itemConfigs = <Item>[];
    for (var oid in oids) {
      final itemConfig = await _client.getItemConfig(oid);
      itemConfigs.add(itemConfig);
    }

    return itemConfigs;
  }

  Future<List<BaseSvc>> pullSvcs() async {
    final svcs = await _client.getSvcList();
    final oids = svcs.map((e) => e.id).toList();
    final configs = <BaseSvc>[];
    for (var oid in oids) {
      try {
        final itemConfig = await _client.getSvcParam(oid);
        configs.add(itemConfig);
      } on UnsupportedService {
        continue;
      }
    }

    return configs;
  }

  void makeConfig(List<Item> items, List<BaseSvc> svcs) async {
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

    final yaml = _yamlWriter.write(map);
    await File("${_config.projectDir}/eva-conf.yaml").writeAsString(yaml);
  }
}
