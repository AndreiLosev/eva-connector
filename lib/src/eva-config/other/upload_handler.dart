import 'dart:convert';

import 'package:eva_connector/eva_connector.dart';

class UploadHandler {
  static const otherUploadConfigName =
      'lvar:eva_connector/system/other_upload_config';

  List<UploadItem>? parseFiles(Map map) {
    return (map['content'][0]['upload'] as List?)
        ?.map((e) => UploadItem.fromConfig(e.cast()))
        .toList();
  }

  Future<void> pullSvcFiles(RpcClient client, List<BaseSvc> svcs) async {
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
        final contnet = await client.fileGet(f.path, FileGetMode.b);
        if (contnet.content == null) continue;
        (svc as HasFiles).putFile(f.path, contnet.content!);
      }
    }
  }

  Future<List<UploadItem>> pullOtherFiles(RpcClient client) async {
    return [];
  }

  List<UploadItem> getSvcFiles(List<BaseSvc> svcs) {
    return svcs
        .whereType<HasFiles>()
        .map((svc) {
          return svc.getFiles();
        })
        .expand((e) => e)
        .toList();
  }

  List<UploadItem>? enrichServicesWithFilesAndGetOtherFiles(
    List<UploadItem>? files,
    Iterable<HasFiles> svcs,
  ) {
    if (files == null) return null;
    final uploads = <UploadItem>[];
    for (var file in files) {
      for (var svc in svcs) {
        if (file.target.startsWith(svc.basePath())) {
          final content = switch (file) {
            UploadItemText() => (utf8.encode(file.secondory), false),
            _ => (<int>[], true),
          };
          svc.putFile(
            file.target.replaceFirst("${svc.basePath()}/", ''),
            content.$1,
            content.$2,
          );
        } else {
          uploads.add(file);
        }
      }
    }

    return uploads;
  }

  List<UploadItem>? mergeServiceFilesAndOther(
    List<BaseSvc> svcs,
    List<UploadItem> upload,
  ) {
    final svcUpload = getSvcFiles(svcs);
    return switch (upload.isEmpty && svcUpload.isEmpty) {
      true => null,
      false => [...svcUpload, ...upload],
    };
  }

  void enrichUploadConfig(
    List<Item> items,
    ExtraList extraList,
    List<UploadItem> otherUpload,
  ) {
    final value = otherUpload.map((e) => e.toConfig()).toList();
    final lvar = Lvar(otherUploadConfigName);
    final extra = EvaExtraItem('lvar.set', {
      'i': otherUploadConfigName,
      'value': value,
    }, false);

    items.add(lvar);
    extraList.afterDeploy.add(extra);
  }

  void sanitizeSystemConfig(List<Item> items, ExtraList extra) {
    for (final item in items) {
      if (item.oid == otherUploadConfigName) {
        items.remove(item);
        break;
      }
    }

    for (final fn in extra.afterDeploy) {
      if (fn is! EvaExtraItem) continue;
      if (fn.method == 'lvar.set' && fn.params?['i'] == otherUploadConfigName) {
        extra.afterDeploy.remove(fn);
        break;
      }
    }
  }
}
