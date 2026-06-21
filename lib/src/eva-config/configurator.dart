import 'package:eva_connector/src/eva-config/factory.dart';
import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/eva-config/other/extra_list.dart';
import 'package:eva_connector/src/eva-config/other/upload_handler.dart';
import 'package:eva_connector/src/eva-config/other/upload_item.dart';
import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/has_files.dart';
import 'package:eva_connector/src/exceptions/unsupported_service.dart';
import 'package:eva_connector/src/rpc/eva_client.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

typedef ConfigLoaded = (
  List<Item>,
  List<BaseSvc>,
  List<UploadItem>?,
  ExtraList? extra,
);

class Configurator {
  final YamlWriter _yamlWriter;
  final Factory _factory;
  final UploadHandler _uploadHandler;

  Configurator(this._yamlWriter, this._factory, this._uploadHandler);

  factory Configurator.short() {
    return Configurator(YamlWriter(), Factory(), UploadHandler());
  }

  Future<ConfigLoaded> pullAll(RpcClient client) async {
    await client.connect();
    final items = await pullItems(client, '*');
    final svcs = await pullSvcs(client);
    await _uploadHandler.pullSvcFiles(client, svcs);

    await client.disconnect();
    return (items, svcs, <UploadItem>[], ExtraList());
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

  Map<String, dynamic> makeMap(
    List<Item> items,
    List<BaseSvc> svcs,
    List<UploadItem> upload,
    ExtraList extra,
  ) {
    final (lvar, extraItem) = _uploadHandler.makeOtheUploadConfig(upload);
    items.add(lvar);
    extra.afterDeploy.add(extraItem);

    return {
      "version": 4,
      "content": [
        {
          "node": ".local",
          "items": items.map((e) => e.toMap()).toList(),
          "svcs": svcs.map((e) => e.toMap()).toList(),
          "upload": ?_uploadHandler
              .mergeServiceFilesAndOther(svcs, upload)
              ?.map((e) => e.toConfig())
              .toList(),
          "extra": ?extra.toConfig(),
        },
      ],
    };
  }

  String makeConfig(
    List<Item> items,
    List<BaseSvc> svcs,
    List<UploadItem> upload,
    ExtraList extra,
  ) {
    return _yamlWriter.write(makeMap(items, svcs, upload, extra));
  }

  (List<Item>, List<BaseSvc>, List<UploadItem>?) loadConfig(String yaml) {
    final map = loadYaml(yaml);
    final items = (map['content'][0]['items'] as List)
        .map((e) => _factory.makeItem(e))
        .toList();

    final svcs = (map['content'][0]['svcs'] as List)
        .map((e) => _factory.makeSvc(e['id'], e['params']))
        .toList();

    final upload = _uploadHandler.parseFiles(
      (map['content'][0]['upload'] as List?)?.cast(),
    );

    final uploads = _uploadHandler.enrichServicesWithFilesAndGetOtherFiles(
      upload,
      svcs.whereType<HasFiles>(),
    );

    final extra = ExtraList(); //TODO: make extra list from config

    _uploadHandler.sanitizeSystemConfig(items, extra);

    return (items, svcs, uploads);
  }

  (List<Item>, List<BaseSvc>) diff(
    (List<Item>, List<BaseSvc>) newCfg,
    (List<Item>, List<BaseSvc>) oldCfg,
  ) {
    final diffItems = <Item>[];
    final diffSvcs = <BaseSvc>[];
    for (final o in oldCfg.$1) {
      newCfg.$1.firstWhere(
        (n) => n.oid == o.oid,
        orElse: () {
          diffItems.add(o);
          return o;
        },
      );
    }
    for (final o in oldCfg.$2) {
      newCfg.$2.firstWhere(
        (n) => n.id == o.id,
        orElse: () {
          diffSvcs.add(o);
          return o;
        },
      );
    }

    return (diffItems, diffSvcs);
  }
}
