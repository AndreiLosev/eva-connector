
import 'package:eva_connector/src/eva-config/svcs/py_macros/py_macros_config.dart';
import 'package:test/test.dart';

void main() {
  group('PyMacrosConfig', () {
    test('loadFromMap should set properties correctly', () {
      final config = PyMacrosConfig();
      final map = {
        'lockerSvc': 'locker',
        'mailerSvc': 'mailer',
        'macroDir': 'new_macro_dir',
        'cvars': {'key': 'value'}
      };
      config.loadFromMap(map);

      expect(config.lockerSvc, 'locker');
      expect(config.mailerSvc, 'mailer');
      expect(config.macroDir, 'new_macro_dir');
      expect(config.cvars, {'key': 'value'});
    });

    test('toMap should return correct map', () {
      final config = PyMacrosConfig();
      config.lockerSvc = 'locker';
      config.mailerSvc = 'mailer';
      config.macroDir = 'macro_dir';
      config.cvars = {'key': 'value'};

      final map = config.toMap();

      expect(map['lockerSvc'], 'locker');
      expect(map['mailerSvc'], 'mailer');
      expect(map['macroDir'], 'macro_dir');
      expect(map['cvars'], {'key': 'value'});
    });
  });
}
      