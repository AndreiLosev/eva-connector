// SPDX-License-Identifier: MIT

import 'package:eva_connector/cron_decoder.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart';

void main() {
  group('CronDecoder', () {
    late CronDecoder decoder;

    setUp(() {
      decoder = CronDecoder();
    });

    group('Validation', () {
      test('Valid 6-field expression', () {
        expect(decoder.isValid('0 0 12 * * ?'), isTrue);
      });

      test('Valid 7-field expression', () {
        expect(decoder.isValid('0 0 12 * * ? *'), isTrue);
      });

      test('Invalid expression (too few fields)', () {
        expect(decoder.isValid('0 0 12 *'), isFalse);
      });

      test('Invalid expression (too many fields)', () {
        expect(decoder.isValid('0 0 12 * * ? * 2024 extra'), isFalse);
      });
    });

    group('Basic expressions', () {
      test('Every second (6 fields)', () {
        final result = decoder.decode('* * * * * ?');
        expect(result, contains('каждую секунду'));
      });

      test('Every second (7 fields)', () {
        final result = decoder.decode('* * * * * ? *');
        expect(result, contains('каждую секунду'));
      });

      test('Every minute at 0 seconds', () {
        final result = decoder.decode('0 * * * ? *');
        expect(result, anyOf(contains('Каждую минуту'), contains('каждую минуту')));
      });

      test('Every hour at 0 minutes and 0 seconds', () {
        final result = decoder.decode('0 0 * * * ? *');
        expect(result, anyOf(contains('каждый час'), contains('Каждый час')));
      });

      test('Every day at 12:00:00', () {
        final result = decoder.decode('0 0 12 * * ? *');
        expect(result, contains('12'));
        expect(result, anyOf(contains('часов'), contains('час')));
      });
    });

    group('Specific times', () {
      test('At 12:00:00 every day', () {
        final result = decoder.decode('0 0 12 * * ? *');
        expect(result, contains('12'));
      });

      test('At 14:30:00 every day', () {
        final result = decoder.decode('0 30 14 * * ? *');
        expect(result, contains('14'));
        expect(result, contains('30'));
      });

      test('At 09:15:30 every day', () {
        final result = decoder.decode('30 15 9 * * ? *');
        expect(result, contains('9'));
        expect(result, contains('15'));
        expect(result, contains('30'));
      });
    });

    group('Step expressions', () {
      test('Every 5 minutes', () {
        final result = decoder.decode('0 */5 * * * ? *');
        expect(result, allOf(contains('5'), contains('минут')));
      });

      test('Every 15 minutes', () {
        final result = decoder.decode('0 */15 * * * ? *');
        expect(result, contains('15'));
      });

      test('Every 30 seconds', () {
        final result = decoder.decode('*/30 * * * * ? *');
        expect(result, allOf(contains('30'), contains('секунд')));
      });

      test('Every hour starting at 0 minutes', () {
        final result = decoder.decode('0 0 */1 * * ? *');
        expect(result, anyOf(contains('каждый час'), contains('Каждый час')));
      });
    });

    group('Ranges', () {
      test('From 9 to 17 hours', () {
        final result = decoder.decode('0 0 9-17 * * ? *');
        expect(result, allOf(contains('9'), contains('17')));
      });

      test('From 1st to 15th day', () {
        final result = decoder.decode('0 0 12 1-15 * ? *');
        expect(result, allOf(contains('1'), contains('15')));
      });

      test('From Monday to Friday', () {
        final result = decoder.decode('0 0 12 ? * MON-FRI *');
        expect(result, anyOf(contains('понедельник'), contains('пятницу')));
      });
    });

    group('Lists', () {
      test('Multiple hours', () {
        final result = decoder.decode('0 0 8,12,18 * * ? *');
        expect(result, allOf(contains('8'), contains('12'), contains('18')));
      });

      test('Multiple months', () {
        final result = decoder.decode('0 0 12 1 * JAN,JUL *');
        expect(result, anyOf(contains('января'), contains('июля')));
      });

      test('Multiple weekdays', () {
        final result = decoder.decode('0 0 12 ? * MON,WED,FRI *');
        expect(result, anyOf(contains('понедельник'), contains('среду'), contains('пятницу')));
      });
    });

    group('Month names', () {
      test('Specific month by name', () {
        final result = decoder.decode('0 0 12 1 JAN ? *');
        expect(result, contains('января'));
      });

      test('Month range by name', () {
        final result = decoder.decode('0 0 12 1 JAN-JUN ? *');
        expect(result, anyOf(contains('января'), contains('июня')));
      });
    });

    group('Weekday names', () {
      test('Specific weekday by name', () {
        final result = decoder.decode('0 0 12 ? * MON *');
        expect(result, contains('понедельник'));
      });

      test('Weekday range by name', () {
        final result = decoder.decode('0 0 12 ? * MON-FRI *');
        expect(result, anyOf(contains('понедельник'), contains('пятницу')));
      });
    });

    group('Special Quartz expressions', () {
      test('Last day of month (L)', () {
        final result = decoder.decode('0 0 12 L * ? *');
        expect(result, allOf(contains('последний'), contains('месяца')));
      });

      test('Last weekday of month (LW)', () {
        final result = decoder.decode('0 0 12 LW * ? *');
        expect(result, allOf(contains('последний'), contains('будний')));
      });

      test('Nth weekday of month (MON#2)', () {
        final result = decoder.decode('0 0 12 ? * MON#2 *');
        expect(result, allOf(contains('понедельник'), contains('#2')));
      });
    });

    group('Year field', () {
      test('Specific year', () {
        final result = decoder.decode('0 0 12 * * ? 2024');
        expect(result, contains('2024'));
      });

      test('Year range', () {
        final result = decoder.decode('0 0 12 * * ? 2024-2030');
        expect(result, allOf(contains('2024'), contains('2030')));
      });

      test('Year step', () {
        final result = decoder.decode('0 0 12 * * ? */2');
        expect(result, allOf(contains('2'), contains('год')));
      });
    });

    group('Question mark field', () {
      test('Question mark in day field', () {
        final result = decoder.decode('0 0 12 ? * MON *');
        expect(result.isNotEmpty, isTrue);
      });

      test('Question mark in weekday field', () {
        final result = decoder.decode('0 0 12 15 * ? *');
        expect(result.isNotEmpty, isTrue);
      });
    });

    group('Detailed decoding', () {
      test('Returns CronDescription with all fields', () {
        final result = decoder.decodeDetailed('0 0 12 * * ? *');
        expect(result.expression, '0 0 12 * * ? *');
        expect(result.description.isNotEmpty, isTrue);
        expect(result.fields.containsKey('second'), isTrue);
        expect(result.fields.containsKey('minute'), isTrue);
        expect(result.fields.containsKey('hour'), isTrue);
        expect(result.fields.containsKey('day'), isTrue);
        expect(result.fields.containsKey('month'), isTrue);
        expect(result.fields.containsKey('weekday'), isTrue);
        expect(result.fields.containsKey('year'), isTrue);
      });
    });
  });
}
