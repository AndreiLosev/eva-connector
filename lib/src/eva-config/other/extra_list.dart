import 'package:eva_connector/src/eva-config/other/extra_item.dart';

class ExtraList {
  final beforeDeploy = <ExtraItem>[];
  final afterDeploy = <ExtraItem>[];
  final beforeUndeploy = <ExtraItem>[];
  final afterUndeploy = <ExtraItem>[];

  Map<String, Map<String, List>> toMap() => {
    'deploy': {
      'before': beforeDeploy.map((e) => e.toConfig()).toList(),
      'after': afterDeploy.map((e) => e.toConfig()).toList(),
    },
    'undeploy': {
      'before': beforeDeploy.map((e) => e.toConfig()).toList(),
      'after': afterDeploy.map((e) => e.toConfig()).toList(),
    },
  };

  Map<String, Map<String, List>>? toConfig() {
    final map = toMap();
    if (beforeDeploy.isEmpty) map['deploy']?.remove('before');
    if (afterDeploy.isEmpty) map['deploy']?.remove('after');
    if (beforeUndeploy.isEmpty) map['undeploy']?.remove('before');
    if (afterUndeploy.isEmpty) map['undeploy']?.remove('after');
    if (map['deploy']?.isEmpty ?? false) map.remove('deploy');
    if (map['undeploy']?.isEmpty ?? false) map.remove('undeploy');

    return map.isEmpty ? null : map;
  }
}
