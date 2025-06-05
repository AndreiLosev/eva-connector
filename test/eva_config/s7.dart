import 'package:eva_connector/src/eva-config/svcs/s7_controller/enums.dart';
import 'package:test/test.dart';
import 'package:eva_connector/src/eva-config/svcs/s7_controller/s7_config.dart';

void main() {
  group('S7Config', () {
    test('loadFromMap should correctly load data', () {
      final data = {
        'ip': '192.168.1.1',
        'port': 102,
        'rack': 1,
        'slot': 2,
        'connection_type': 3,
        'pull_cache_sec': 3600,
        'pull_interval': 2.0,
        'pull': [],
        'action_map': {},
      };
      final s7Config = S7Config();
      s7Config.loadFromMap(data);

      expect(s7Config.ip, '192.168.1.1');
      expect(s7Config.port, 102);
      expect(s7Config.rack, 1);
      expect(s7Config.slot, 2);
      expect(s7Config.connectionType, 3);
      expect(s7Config.pullCacheSec, 3600);
      expect(s7Config.pullInterval, 2.0);
      expect(s7Config.pull, []);
      expect(s7Config.actionMap, {});
    });

    test('toMap should correctly convert to map', () {
      final s7Config = S7Config()
        ..ip = '192.168.1.1'
        ..port = 102
        ..rack = 1
        ..slot = 2
        ..connectionType = 3
        ..pullCacheSec = 3600
        ..pullInterval = 2.0
        ..pull = []
        ..actionMap = {};

      final map = s7Config.toMap();

      expect(map['ip'], '192.168.1.1');
      expect(map['port'], 102);
      expect(map['rack'], 1);
      expect(map['slot'], 2);
      expect(map['connection_type'], 3);
      expect(map['pull_cache_sec'], 3600);
      expect(map['pull_interval'], 2.0);
      expect(map['pull'], []);
      expect(map['action_map'], {});
    });
  });

  group('Transform', () {
    test('fromMap should correctly create Transform object', () {
      final map = {
        'func': 'add',
        'params': [1, 2],
      };
      final transform = Transform.fromMap(map);

      expect(transform.func, TransformFunc.add);
      expect(transform.params, [1, 2]);
    });

    test('toMap should correctly convert Transform to map', () {
      final transform = Transform(func: TransformFunc.add, params: [1, 2]);
      final map = transform.toMap();

      expect(map['func'], 'add');
      expect(map['params'], [1, 2]);
    });
  });
}

