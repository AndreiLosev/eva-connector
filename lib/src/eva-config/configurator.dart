import 'package:eva_connector/src/eva-config/factory.dart';
import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/has_files.dart';
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

  Future<(List<Item>, List<BaseSvc>)> pullAll(RpcClient client) async {
    await client.connect();
    final items = await pullItems(client, '*');
    final svcs = await pullSvcs(client);
    await pullFiles(client, svcs);

    await client.disconnect();
    return (items, svcs);
  }

  Future<List<Item>> pullItems(RpcClient client, String oidPattern) async {
    final items = await client.getItmesList(oidPattern);
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

  Future<void> pullFiles(RpcClient client, List<BaseSvc> svcs) async {
    for (var svc in svcs) {
      if (svc is! HasFiles) {
        continue;
      }
      final files = await client.list(
        (svc as HasFiles).basePath(),
        null,
        'file',
        true,
      );

      for (var f in files) {
        final contnet = await client.fileGet(f.path, FileGetMode.t);
        (svc as HasFiles).putFile(f.path, contnet.text?.trim() ?? '');
      }
    }
  }

  String makeConfig(List<Item> items, List<BaseSvc> svcs) {
    final map = {
      "version": 4,
      "content": [
        {
          "node": ".local",
          "items": items.map((e) => e.toMap()).toList(),
          "svcs": svcs.map((e) => e.toMap()).toList(),
          "upload": svcs
              .whereType<HasFiles>()
              .map((svc) {
                final files = svc.getFiles().entries.map(
                  (e) => {
                    'text': e.value.trim(),
                    'target': '${svc.basePath()}/${e.key}',
                  },
                );
                return List.from(files);
              })
              .expand((e) => e)
              .toList(),
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

    parseFiles(
      (map['content'][0]['upload'] as List?)?.cast(),
      svcs.whereType<HasFiles>(),
    );

    return (items, svcs);
  }

  void parseFiles(List<Map<String, String>>? files, Iterable<HasFiles> svcs) {
    if (files == null) return;
    for (var file in files) {
      for (var svc in svcs) {
        if (file['target']?.startsWith(svc.basePath()) ?? false) {
          svc.putFile(
            file['target']!.replaceFirst("${svc.basePath()}/", ''),
            file['text'] ?? '',
          );
        }
      }
    }
  }
}
