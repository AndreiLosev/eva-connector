import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/eva-config/items/item_handler.dart';
import 'package:eva_connector/src/eva-config/other/extra_handelr.dart';
import 'package:eva_connector/src/eva-config/other/upload_handler.dart';
import 'package:eva_connector/src/eva-config/svcs/svc_handler.dart';

typedef ConfigLoaded = (
  List<Item>,
  List<BaseSvc>,
  List<UploadItem>?,
  ExtraList?,
);

class Configurator {
  final YamlWriter _yamlWriter;
  final ItemHandler _itemHandler;
  final SvcHandler _svcHandler;
  final UploadHandler _uploadHandler;
  final ExtraHandelr _extraHandler;

  Configurator(
    this._yamlWriter,
    this._itemHandler,
    this._svcHandler,
    this._uploadHandler,
    this._extraHandler,
  );

  factory Configurator.short() {
    return Configurator(
      YamlWriter(),
      ItemHandler(),
      SvcHandler(),
      UploadHandler(),
      ExtraHandelr(),
    );
  }

  Future<ConfigLoaded> pullAll(RpcClient client) async {
    final items = await _itemHandler.pull(client, '*');
    final svcs = await _svcHandler.pull(client);
    await _uploadHandler.pullSvcFiles(client, svcs);
    return (items, svcs, <UploadItem>[], ExtraList());
  }

  Map<String, dynamic> makeMap(
    List<Item> items,
    List<BaseSvc> svcs,
    List<UploadItem> upload,
    ExtraList extra,
  ) {
    _uploadHandler.enrichUploadConfig(items, extra, upload);
    _extraHandler.enrichUploadConfig(items, extra);

    return {
      "version": 4,
      "content": [
        {
          "node": ".local",
          "items": _itemHandler.toConfig(items),
          "svcs": _svcHandler.toConfig(svcs),
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
    final items = _itemHandler.parse(map);

    final svcs = _svcHandler.parse(map);

    final upload = _uploadHandler.parseFiles(map);

    final uploads = _uploadHandler.enrichServicesWithFilesAndGetOtherFiles(
      upload,
      svcs.whereType<HasFiles>(),
    );

    final extra = _extraHandler.parseConfig(map);

    _uploadHandler.sanitizeSystemConfig(items, extra);
    _extraHandler.sanitizeSystemConfig(items, extra);

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
