// SPDX-License-Identifier: MIT

import 'cron_field.dart';

/// Day of month field (1-31)
/// Supports: numbers, *, ?, L, W, LW, ?
class DayField extends CronField {
  DayField(String value) : super(value, 1, 31);

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
      return 'каждый день';
    }
    if (isSpecific) {
      return '${_formatDay(specificValue!)}';
    }
    
    // Handle step expressions
    if (rawValue.contains('/')) {
      final parts = rawValue.split('/');
      if (parts[0] == '*' && parts.length == 2) {
        final step = int.tryParse(parts[1]) ?? 1;
        return 'каждые $step ${_getDayEnding(step)}';
      }
    }
    
    // Handle L (last day of month)
    if (rawValue == 'L') {
      return 'последний день месяца';
    }
    
    // Handle LW (last weekday of month)
    if (rawValue == 'LW') {
      return 'последний будний день месяца';
    }
    
    // Handle W (nearest weekday)
    if (rawValue.endsWith('W')) {
      final dayPart = rawValue.substring(0, rawValue.length - 1);
      final day = int.tryParse(dayPart) ?? 1;
      return '$day числа или ближайший будний';
    }
    
    // Handle ranges
    if (rawValue.contains('-')) {
      return 'с ${_formatDay(resolvedValues.first)} по ${_formatDay(resolvedValues.last)}';
    }
    
    // Handle lists
    if (rawValue.contains(',')) {
      return '${resolvedValues.map((d) => _formatDay(d)).join(", ")} числа';
    }
    
    return '${_formatDay(resolvedValues.first)} числа';
  }

  String _formatDay(int day) {
    // In Russian, we usually just say the number with "число" or "день"
    return '$day';
  }

  String _getDayEnding(int value) {
    if (value == 1) return 'день';
    if (value >= 2 && value <= 4) return 'дня';
    return 'дней';
  }
}

/// Parse helper with special Quartz expressions
List<int> _parseField(String value, int min, int max) {
  if (value == '*' || value == '?') {
    return List.generate(max - min + 1, (i) => min + i);
  }
  
  // Handle special expressions: L, W, LW
  if (value == 'L') {
    // Last day of month - we return a special value or the max
    // In Quartz, this means the last day of the month
    // For parsing purposes, we'll return [31] as a placeholder
    // The actual "last day" is context-dependent (month-specific)
    return [31];
  }
  
  if (value == 'LW') {
    // Last weekday of month
    return [31]; // Placeholder
  }
  
  if (value.endsWith('W')) {
    final dayPart = value.substring(0, value.length - 1);
    final day = int.tryParse(dayPart) ?? 1;
    if (day >= min && day <= max) {
      return [day];
    }
    return [min];
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
  
  final numValue = int.tryParse(value);
  if (numValue != null && numValue >= min && numValue <= max) {
    return [numValue];
  }
  
  return [min];
}

List<int> _parseRange(String value, int min, int max) {
  final parts = value.split('-');
  if (parts.length != 2) return [];
  
  final start = int.tryParse(parts[0]) ?? min;
  final end = int.tryParse(parts[1]) ?? max;
  
  final result = <int>[];
  for (var i = start; i <= end && i <= max; i++) {
    if (i >= min) {
      result.add(i);
    }
  }
  return result;
}
