import 'package:eva_connector/eva_connector.dart';

class SvcHandler {
  BaseSvc makeSvc(String id, Map map) {
    final BaseSvc svc = switch (map['command']) {
      ModbusController.svcCommand => ModbusController(id),
      S7Controller.svcCommand => S7Controller(id),
      DbSqlHistory.svcCommand => DbSqlHistory(id),
      LogicManager.svcCommand => LogicManager(id),
      PyMacros.svcCommand => PyMacros(id),
      SharedLockService.svcCommand => SharedLockService(id),
      ItemStateExpirationService.svcCommand => ItemStateExpirationService(id),
      MqttController.svcCommand => MqttController(id),
      HmiService.svcCommand => HmiService(id),
      ScriptRunnerController.svcCommand => ScriptRunnerController(id),
      SystemMonitoringService.svcCommand => SystemMonitoringService(id),
      EventService.svcCommand => EventService(id),
      _ => UnknownService(id),
    };

    svc.loadFromMap(map);

    return svc;
  }

  Future<List<BaseSvc>> pull(RpcClient client) async {
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

  List<Map<String, dynamic>> toConfig(List<BaseSvc> svcs) {
    return svcs.map((e) => e.toMap()).toList();
  }

  List<BaseSvc> parse(Map map) {
    return (map['content'][0]['svcs'] as List)
        .map((e) => makeSvc(e['id'], e['params']))
        .toList();
  }
}
