// SPDX-License-Identifier: MIT

import 'fields/second_field.dart';
import 'fields/minute_field.dart';
import 'fields/hour_field.dart';
import 'fields/day_field.dart';
import 'fields/month_field.dart';
import 'fields/weekday_field.dart';
import 'fields/year_field.dart';

/// Represents a parsed cron expression with 6 or 7 fields
/// Format: second minute hour day month weekday [year]
class CronExpression {
  final String rawExpression;
  
  late final SecondField second;
  late final MinuteField minute;
  late final HourField hour;
  late final DayField day;
  late final MonthField month;
  late final WeekdayField weekday;
  late final YearField? year;
  
  final List<String> fieldValues;
  final int fieldCount;
  
  // Whether the expression has a year field (7 fields)
  final bool hasYear;

  CronExpression(this.rawExpression) : 
    fieldValues = rawExpression.trim().split(RegExp(r'\s+')),
    fieldCount = rawExpression.trim().split(RegExp(r'\s+')).length,
    hasYear = rawExpression.trim().split(RegExp(r'\s+')).length == 7 {
    
    if (fieldCount != 6 && fieldCount != 7) {
      throw FormatException('Invalid cron expression: must have 6 or 7 fields, got $fieldCount');
    }
    
    _parse();
  }

  void _parse() {
    final fields = fieldValues;
    
    second = SecondField(fields[0]);
    second.parse();
    
    minute = MinuteField(fields[1]);
    minute.parse();
    
    hour = HourField(fields[2]);
    hour.parse();
    
    day = DayField(fields[3]);
    day.parse();
    
    month = MonthField(fields[4]);
    month.parse();
    
    weekday = WeekdayField(fields[5]);
    weekday.parse();
    
    if (hasYear) {
      year = YearField(fields[6]);
      year!.parse();
    } else {
      year = null;
    }
  }

  /// Validate the cron expression
  static bool isValid(String expression) {
    try {
      CronExpression(expression);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get all field raw values
  List<String> getFieldValues() => List.from(fieldValues);

  /// Check if this is a 7-field expression (with year)
  bool get isSevenField => fieldCount == 7;

  /// Check if this is a 6-field expression (without year)
  bool get isSixField => fieldCount == 6;

  /// Get the year field, or a default "any year" field
  YearField get yearField {
    if (year != null) {
      return year!;
    }
    // Create a default "any year" field
    final defaultYear = YearField('*');
    defaultYear.parse();
    return defaultYear;
  }
}
