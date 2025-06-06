import 'package:test/test.dart';
import 'package:eva_connector/src/eva-config/svcs/logic_manager/logic_manager_config.dart';
import 'package:eva_connector/src/eva-config/svcs/logic_manager/rule.dart';
import 'package:eva_connector/src/eva-config/svcs/logic_manager/cycle.dart';
import 'package:eva_connector/src/eva-config/svcs/logic_manager/jobs.dart';

void main() {
  group('LogicManagerConfig', () {
    test('toMap with empty lists', () {
      final config = LogicManagerConfig();
      final map = config.toMap();
      expect(map['rules'], isEmpty);
      expect(map['cycles'], isEmpty);
      expect(map['jobs'], isEmpty);
    });

    test('toMap with populated lists', () {
      final config = LogicManagerConfig()
        ..rules = [Rule('oid1', 'rule1', 'run1')]
        ..cycles = [Cycle('cycle1', 'run1')]
        ..jobs = [Job('job1', 'run1')];
      final map = config.toMap();
      expect(map['rules'], isNotEmpty);
      expect(map['cycles'], isNotEmpty);
      expect(map['jobs'], isNotEmpty);
    });

    test('loadFromMap with empty map', () {
      final config = LogicManagerConfig();
      config.loadFromMap({});
      expect(config.rules, isEmpty);
      expect(config.cycles, isEmpty);
      expect(config.jobs, isEmpty);
    });

    test('loadFromMap with populated map', () {
      final config = LogicManagerConfig();
      config.loadFromMap({
        'rules': [
          {'oid': 'oid1', 'id': 'rule1', 'run': 'run1'},
        ],
        'cycles': [
          {'id': 'cycle1', 'run': 'run1'},
        ],
        'jobs': [
          {'id': 'job1', 'run': 'run1'},
        ],
        'openers': [
          {'oid': 'opener1'},
        ],
      });
      expect(config.rules, isNotEmpty);
      expect(config.cycles, isNotEmpty);
      expect(config.jobs, isNotEmpty);
    });
  });
}

