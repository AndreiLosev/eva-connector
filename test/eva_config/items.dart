import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/eva-config/items/action.dart';
import 'package:test/test.dart';

void main() {
  group('Sensor', () {
    test('Sensor should have correct name', () {
      expect(Sensor.name, 'sensor');
    });
  });

  group('Lvar', () {
    test('Lvar should have correct name', () {
      expect(Lvar.name, 'lvar');
    });
  });

  group('Unit', () {
    test('toMap should include action if present', () {
      final action = Action("eva.test");
      final unit = Unit('123');
      unit.action = action;
      final map = unit.toMap();
      expect(map, {'enabled': true, 'oid': '123', 'action': action.toMap()});
    });

    test('loadFromMap should set action correctly', () {
      final action = Action('eva.test');
      final unit = Unit('123');
      unit.loadFromMap({
        'enabled': false,
        'oid': '456',
        'action': action.toMap(),
      });
      expect(unit.enabled, false);
      expect(unit.oid, '456');
      expect(unit.action?.svc, action.svc);
    });

    test('makeAction should return null if map is null', () {
      final unit = Unit('123');
      expect(unit.makeAction(null), isNull);
    });

    test('makeAction should return Action if map is not null', () {
      final action = Action("test");
      final unit = Unit('123');
      final map = action.toMap();
      expect(unit.makeAction(map), isA<Action>());
    });
  });

  group('Lmacro', () {
    test('toMap should include action if present', () {
      final action = Action("test");
      final lmacro = Lmacro('123');
      lmacro.action = action;
      final map = lmacro.toMap();
      expect(map, {'enabled': true, 'oid': '123', 'action': action.toMap()});
    });

    test('loadFromMap should set action correctly', () {
      final action = Action("test");
      final lmacro = Lmacro('123');
      lmacro.loadFromMap({
        'enabled': false,
        'oid': '456',
        'action': action.toMap(),
      });
      expect(lmacro.enabled, false);
      expect(lmacro.oid, '456');
      expect(lmacro.action?.svc, action.svc);
    });
  });
}
