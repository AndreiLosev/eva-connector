import 'package:eva_connector/eva_connector.dart';

class ExtraHandelr {
  static const extraConfigName = 'lvar:eva_connector/system/extra_config';

  ExtraList parseConfig(Map map) {
    final extraMap = map['content'][0]['extra'];
    final extraList = ExtraList();
    final types = [
      ('deploy', 'before', extraList.beforeDeploy),
      ('deploy', 'after', extraList.afterDeploy),
      ('undeploy', 'after', extraList.afterUndeploy),
      ('undeploy', 'before', extraList.beforeUndeploy),
    ];

    for (final (k1, k2, list) in types) {
      if (extraMap[k1] is Map) {
        if (extraMap[k1][k2] is List) {
          for (final raw in (extraMap[k1][k2] as List)) {
            if (raw is! Map) continue;
            list.add(ExtraItem.fromConfig(raw));
          }
        }
      }
    }

    return extraList;
  }

  void enrichUploadConfig(List<Item> items, ExtraList extraList) {
    final value = extraList.toConfig();
    final lvar = Lvar(extraConfigName);
    final extra = EvaExtraItem('lvar.set', {
      'i': extraConfigName,
      'value': value,
    }, false);

    items.add(lvar);
    extraList.afterDeploy.add(extra);
  }

  void sanitizeSystemConfig(List<Item> items, ExtraList extra) {
    for (final item in items) {
      if (item.oid == extraConfigName) {
        items.remove(item);
        break;
      }
    }

    for (final fn in extra.afterDeploy) {
      if (fn is! EvaExtraItem) continue;
      if (fn.method == 'lvar.set' && fn.params?['i'] == extraConfigName) {
        extra.afterDeploy.remove(fn);
        break;
      }
    }
  }
}
