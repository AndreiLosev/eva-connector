// SPDX-License-Identifier: MIT

import 'cron_field.dart';

/// Weekday field (1-7 where 1=Sunday or 2=Monday, depending on standard)
/// In Quartz: 1-7 where 1=Sunday, 2=Monday, ..., 7=Saturday
/// Also supports: names (SUN, MON, TUE, WED, THU, FRI, SAT), *, ?, L, #, W
class WeekdayField extends CronField {
  static const Map<String, int> weekdayNames = {
    'SUN': 1, 'SUNDAY': 1,
    'MON': 2, 'MONDAY': 2,
    'TUE': 3, 'TUESDAY': 3,
    'WED': 4, 'WEDNESDAY': 4,
    'THU': 5, 'THURSDAY': 5,
    'FRI': 6, 'FRIDAY': 6,
    'SAT': 7, 'SATURDAY': 7,
  };

  static const Map<int, String> weekdayNamesRu = {
    1: 'воскресенье',
    2: 'понедельник',
    3: 'вторник',
    4: 'среду',
    5: 'четверг',
    6: 'пятницу',
    7: 'субботу',
  };

  WeekdayField(String value) : super(value, 1, 7);

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
      return 'каждый день недели';
    }
    if (isSpecific) {
      return '${_getWeekdayNameRu(specificValue!)}';
    }
    
    // Handle step expressions
    if (rawValue.contains('/')) {
      final parts = rawValue.split('/');
      if (parts[0] == '*' && parts.length == 2) {
        final step = int.tryParse(parts[1]) ?? 1;
        return 'каждые $step ${_getWeekdayEnding(step)}';
      }
    }
    
    // Handle L (last day of week in month)
    if (rawValue == 'L') {
      return 'последний день недели месяца';
    }
    
    // Handle # (nth weekday of month) e.g., MON#2
    final hashIndex = rawValue.indexOf('#');
    if (hashIndex > 0) {
      final weekdayPart = rawValue.substring(0, hashIndex);
      final nPart = rawValue.substring(hashIndex + 1);
      final n = int.tryParse(nPart) ?? 1;
      var weekday = _parseSingleWeekday(weekdayPart, 1);
      
      // Parse weekday name or number
      if (weekday == 1 && weekdayPart.isNotEmpty) {
        final upperPart = weekdayPart.toUpperCase();
        if (weekdayNames.containsKey(upperPart)) {
          weekday = weekdayNames[upperPart]!;
        }
      }
      
      return '${_getWeekdayNameRu(weekday)}#$n';
    }
    
    // Handle W (nearest weekday) - not typically used in weekday field
    if (rawValue.endsWith('W')) {
      final weekdayPart = rawValue.substring(0, rawValue.length - 1);
      var weekday = int.tryParse(weekdayPart) ?? 1;
      if (weekday >= minValue && weekday <= maxValue) {
        return '${_getWeekdayNameRu(weekday)} или ближайший будний';
      }
    }
    
    // Handle ranges
    if (rawValue.contains('-')) {
      return '${_getWeekdayNameRu(resolvedValues.first)} по ${_getWeekdayNameRu(resolvedValues.last)}';
    }
    
    // Handle lists
    if (rawValue.contains(',')) {
      return '${resolvedValues.map((w) => _getWeekdayNameRu(w)).join(", ")}';
    }
    
    return '${resolvedValues.map((w) => _getWeekdayNameRu(w)).join(", ")}';
  }

  String _getWeekdayNameRu(int weekday) {
    // Quartz uses 1-7 where 1=Sunday
    // But some systems use 1-7 where 1=Monday
    // We'll assume Quartz standard: 1=Sunday
    return weekdayNamesRu[weekday] ?? '$weekday день недели';
  }

  String _getWeekdayEnding(int value) {
    if (value == 1) return 'день недели';
    if (value >= 2 && value <= 4) return 'дня недели';
    return 'дней недели';
  }
}

/// Parse helper
List<int> _parseField(String value, int min, int max) {
  if (value == '*' || value == '?') {
    return List.generate(max - min + 1, (i) => min + i);
  }
  
  // Handle special expressions: L
  if (value == 'L') {
    // Last day of week in month - we return a placeholder
    return [7]; // Saturday as placeholder
  }
  
  // Handle # (nth weekday of month)
  final hashIndex = value.indexOf('#');
  if (hashIndex > 0) {
    final weekdayPart = value.substring(0, hashIndex);
    final nPart = value.substring(hashIndex + 1);
    final n = int.tryParse(nPart) ?? 1;
    var weekday = _parseSingleWeekday(weekdayPart, 1);
    
    // For now, we return the weekday number
    // The actual "nth weekday" is context-dependent
    if (weekday >= min && weekday <= max) {
      return [weekday];
    }
    return [1];
  }
  
  // Handle W (not typically used in weekday field)
  if (value.endsWith('W')) {
    final weekdayPart = value.substring(0, value.length - 1);
    final weekday = int.tryParse(weekdayPart);
    if (weekday != null && weekday >= min && weekday <= max) {
      return [weekday];
    }
    return [1];
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
  
  // Try to parse as weekday name
  final upperValue = value.toUpperCase();
  if (WeekdayField.weekdayNames.containsKey(upperValue)) {
    return [WeekdayField.weekdayNames[upperValue]!];
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
  
  final start = _parseSingleWeekday(parts[0], min);
  final end = _parseSingleWeekday(parts[1], max);
  
  final result = <int>[];
  for (var i = start; i <= end && i <= max; i++) {
    if (i >= min) {
      result.add(i);
    }
  }
  return result;
}

int _parseSingleWeekday(String value, int defaultValue) {
  final upperValue = value.toUpperCase();
  if (WeekdayField.weekdayNames.containsKey(upperValue)) {
    return WeekdayField.weekdayNames[upperValue]!;
  }
  final numValue = int.tryParse(value);
  if (numValue != null) {
    return numValue;
  }
  return defaultValue;
}
