
import 'package:eva_connector/src/eva-config/svcs/py_macros/py_macros_config.dart';
import 'package:test/test.dart';

void main() {
  group('PyMacrosConfig', () {
    test('loadFromMap should set properties correctly', () {
      final config = PyMacrosConfig();
      final map = {
        'locker_svc': 'locker',
        'mailer_svc': 'mailer',
        'alarm_svc': 'alarm',
        'macro_dir': 'new_macro_dir',
        'cvars': {'key': 'value'}
      };
      config.loadFromMap(map);

      expect(config.lockerSvc, 'locker');
      expect(config.mailerSvc, 'mailer');
      expect(config.alarmSvc, 'alarm');
      expect(config.macroDir, 'new_macro_dir');
      expect(config.cvars, {'key': 'value'});
    });

    test('toMap should return correct map', () {
      final config = PyMacrosConfig();
      config.lockerSvc = 'locker';
      config.mailerSvc = 'mailer';
      config.alarmSvc = 'alarm';
      config.macroDir = 'macro_dir';
      config.cvars = {'key': 'value'};

      final map = config.toMap();

      expect(map['locker_svc'], 'locker');
      expect(map['mailer_svc'], 'mailer');
      expect(map['alarm_svc'], 'alarm');
      expect(map['macro_dir'], 'macro_dir');
      expect(map['cvars'], {'key': 'value'});
    });

    test('toMap should not include null optional fields', () {
      final config = PyMacrosConfig();
      config.macroDir = 'macro_dir';
      config.cvars = {'key': 'value'};

      final map = config.toMap();

      expect(map.containsKey('locker_svc'), false);
      expect(map.containsKey('mailer_svc'), false);
      expect(map.containsKey('alarm_svc'), false);
      expect(map['macro_dir'], 'macro_dir');
      expect(map['cvars'], {'key': 'value'});
    });
  });
}
      