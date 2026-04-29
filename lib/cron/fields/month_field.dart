// SPDX-License-Identifier: MIT

import 'cron_field.dart';

/// Month field (1-12)
/// Supports: numbers, names (JAN, FEB, ..., DEC), *, ?, ranges, steps, lists
class MonthField extends CronField {
  static const Map<String, int> monthNames = {
    'JAN': 1, 'JANUARY': 1,
    'FEB': 2, 'FEBRUARY': 2,
    'MAR': 3, 'MARCH': 3,
    'APR': 4, 'APRIL': 4,
    'MAY': 5,
    'JUN': 6, 'JUNE': 6,
    'JUL': 7, 'JULY': 7,
    'AUG': 8, 'AUGUST': 8,
    'SEP': 9, 'SEPTEMBER': 9,
    'OCT': 10, 'OCTOBER': 10,
    'NOV': 11, 'NOVEMBER': 11,
    'DEC': 12, 'DECEMBER': 12,
  };

  static const Map<int, String> monthNamesRu = {
    1: 'января',
    2: 'февраля',
    3: 'марта',
    4: 'апреля',
    5: 'мая',
    6: 'июня',
    7: 'июля',
    8: 'августа',
    9: 'сентября',
    10: 'октября',
    11: 'ноября',
    12: 'декабря',
  };

  MonthField(String value) : super(value, 1, 12);

  @override
  void parse() {
    resolvedValues = _parseField(rawValue, minValue, maxValue);
    humanReadable = _toHumanReadable();
  }

  @override
  List<int> getValues() => resolvedValues;

  @override
  String toHumanReadable() => humanReadable;

  String _toHumanReadable() {
    if (isAny) {
      return 'каждый месяц';
    }
    if (isSpecific) {
      return 'в ${_getMonthNameRu(specificValue!)}';
    }
    
    // Handle step expressions
    if (rawValue.contains('/')) {
      final parts = rawValue.split('/');
      if (parts[0] == '*' && parts.length == 2) {
        final step = int.tryParse(parts[1]) ?? 1;
        return 'каждые $step ${_getMonthEnding(step)}';
      }
    }
    
    // Handle ranges
    if (rawValue.contains('-')) {
      return 'с ${_getMonthNameRu(resolvedValues.first)} по ${_getMonthNameRu(resolvedValues.last)}';
    }
    
    // Handle lists
    if (rawValue.contains(',')) {
      return 'в ${resolvedValues.map((m) => _getMonthNameRu(m)).join(", ")}';
    }
    
    return 'в ${resolvedValues.map((m) => _getMonthNameRu(m)).join(", ")}';
  }

  String _getMonthNameRu(int month) {
    return monthNamesRu[month] ?? '$month месяца';
  }

  String _getMonthEnding(int value) {
    if (value == 1) return 'месяц';
    if (value >= 2 && value <= 4) return 'месяца';
    return 'месяцев';
  }
}

/// Parse helper
List<int> _parseField(String value, int min, int max) {
  if (value == '*' || value == '?') {
    return List.generate(max - min + 1, (i) => min + i);
  }
  
  if (value.contains('/')) {
    final parts = value.split('/');
    final base = parts[0];
    final step = int.tryParse(parts[1]) ?? 1;
    
    if (base == '*') {
      return List.generate(((max - min) ~/ step) + 1, (i) => min + i * step)
          .where((v) => v <= max)
          .toList();
    } else {
      final rangeValues = _parseRange(base, min, max);
      return rangeValues.where((v) => v >= min && v <= max).toList();
    }
  }
  
  if (value.contains('-')) {
    return _parseRange(value, min, max);
  }
  
  if (value.contains(',')) {
    final parts = value.split(',');
    final result = <int>[];
    for (final part in parts) {
      result.addAll(_parseField(part, min, max));
    }
    return result.toSet().toList()..sort();
  }
  
  // Try to parse as month name
  final upperValue = value.toUpperCase();
  if (MonthField.monthNames.containsKey(upperValue)) {
    return [MonthField.monthNames[upperValue]!];
  }
  
  // Try to parse as number
  final numValue = int.tryParse(value);
  if (numValue != null && numValue >= min && numValue <= max) {
    return [numValue];
  }
  
  return [min];
}

List<int> _parseRange(String value, int min, int max) {
  final parts = value.split('-');
  if (parts.length != 2) return [];
  
  final start = _parseSingleMonth(parts[0], min);
  final end = _parseSingleMonth(parts[1], max);
  
  final result = <int>[];
  for (var i = start; i <= end && i <= max; i++) {
    if (i >= min) {
      result.add(i);
    }
  }
  return result;
}

int _parseSingleMonth(String value, int defaultValue) {
  final upperValue = value.toUpperCase();
  if (MonthField.monthNames.containsKey(upperValue)) {
    return MonthField.monthNames[upperValue]!;
  }
  final numValue = int.tryParse(value);
  if (numValue != null) {
    return numValue;
  }
  return defaultValue;
}
