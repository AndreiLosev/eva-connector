import 'package:test/test.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/modbus_config.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/action_map_item.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/enums.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/map_item.dart';
import 'package:eva_connector/src/eva-config/svcs/modbus_controller/modbus_register.dart';

void main() {
  group('ModbusConfig', () {
    test('initializes with default values', () {
      final config = ModbusConfig();
      expect(config.actionQueueSize, 32);
      expect(config.actionsVerify, true);
      expect(config.modbus.path, "127.0.0.1:502");
      expect(config.modbus.protocol, ModbusProtocol.tcp);
      expect(config.modbus.unit, 1);
      expect(config.panicIn, null);
      expect(config.pullCacheSec, 360);
      expect(config.pullInterval, 2);
      expect(config.queueSize, 32768);
      expect(config.retries, 2);
      expect(config.pull, []);
      expect(config.actionMap, {});
    });

    test('toMap returns correct map', () {
      final config = ModbusConfig();
      final map = config.toMap();
      expect(map['action_queue_size'], 32);
      expect(map['actions_verify'], true);
      expect(map['modbus']['path'], "127.0.0.1:502");
      expect(map['modbus']['protocol'], 'tcp');
      expect(map['modbus']['unit'], 1);
      expect(map['panic_in'], null);
      expect(map['pull_cache_sec'], 360);
      expect(map['pull_interval'], 2);
      expect(map['queue_size'], 32768);
      expect(map['retries'], 2);
      expect(map['pull'], []);
      expect(map['action_map'], {});
    });

    test('toMap handles pull list correctly', () {
      final config = ModbusConfig();
      config.pull.add((
        count: 1,
        unit: 1,
        reg: Holding(12),
        map: [MapItem("sensor:test")],
      ));
      final map = config.toMap();
      expect(map['pull'], isNotEmpty);
      expect(map['pull'][0]['count'], 1);
      expect(map['pull'][0]['unit'], 1);
      expect(map['pull'][0]['reg'], 'h12');
      expect(map['pull'][0]['map'], [MapItem("sensor:test").toMap()]);
    });

    test('toMap handles actionMap correctly', () {
      final config = ModbusConfig();
      config.actionMap['test'] = ActionMapItem();
      final map = config.toMap();
      expect(map['action_map'], isNotEmpty);
      expect(map['action_map']['test'], ActionMapItem().toMap());
    });
  });
}
