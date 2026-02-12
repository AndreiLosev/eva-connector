import 'package:test/test.dart';
import 'package:eva_connector/src/eva-config/svcs/db_sql/db_sql_config.dart';

void main() {
  group('DbSqlConfig', () {
    test('toMap should return correct map', () {
      final config = DbSqlConfig();
      final map = config.toMap();
      expect(map['db'], equals('sqlite:///tmp/eva_history.db'));
      expect(map['buf_ttl_sec'], isNull);
      expect(map['interval'], isNull);
      expect(map['skip_disconnected'], isFalse);
      expect(map['ignore_events'], isFalse);
      expect(map['simple_cleaning'], isFalse);
      expect(map['keep'], equals(604800));
      expect(map['queue_size'], equals(8192));
      expect(map['panic_in'], equals(0));
      expect(map['oids'], equals(['*']));
      expect(map['oids_exclude'], isEmpty);
    });

    test('loadFromMap should load values correctly', () {
      final config = DbSqlConfig();
      final map = {
        'db': 'sqlite:///test.db',
        'buf_ttl_sec': 3600,
        'interval': 10,
        'skip_disconnected': true,
        'ignore_events': true,
        'simple_cleaning': true,
        'keep': 3600,
        'queue_size': 4096,
        'panic_in': 5,
        'oids': ['1', '2'],
        'oids_exclude': ['3'],
      };
      config.loadFromMap(map);
      expect(config.db, equals('sqlite:///test.db'));
      expect(config.bufTtlSec, equals(3600));
      expect(config.interval, equals(10));
      expect(config.skipDisconnected, isTrue);
      expect(config.ignoreEvents, isTrue);
      expect(config.keep, equals(3600));
      expect(config.queueSize, equals(4096));
      expect(config.panicIn, equals(5));
      expect(config.oids, equals(['1', '2']));
      expect(config.oidsExclude, equals(['3']));
    });
  });
}
