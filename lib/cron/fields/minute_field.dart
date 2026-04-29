// SPDX-License-Identifier: MIT

import 'cron_field.dart';

/// Minute field (0-59)
class MinuteField extends CronField {
  MinuteField(String value) : super(value, 0, 59);

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
      return 'каждую минуту';
    }
    if (isSpecific) {
      final v = specificValue!;
      return _formatMinute(v);
    }
    
    // Handle step expressions like */5
    if (rawValue.contains('/')) {
      final parts = rawValue.split('/');
      if (parts[0] == '*' && parts.length == 2) {
        final step = int.tryParse(parts[1]) ?? 1;
        if (step == 1) return 'каждую минуту';
        return 'каждые $step ${_getMinuteEnding(step)}';
      }
    }
    
    // Handle ranges
    if (rawValue.contains('-')) {
      return 'с ${resolvedValues.first} по ${resolvedValues.last} минуту';
    }
    
    // Handle lists
    if (rawValue.contains(',')) {
      return 'в ${_formatMinuteList(resolvedValues)}';
    }
    
    return 'в ${_formatMinuteList(resolvedValues)}';
  }

  String _formatMinute(int value) {
    if (value == 0) return 'в 0 минут';
    return 'в $value ${_getMinuteEnding(value)}';
  }

  String _formatMinuteList(List<int> values) {
    if (values.length == 1) return _formatMinute(values.first);
    return 'минуты ${values.join(", ")}';
  }

  String _getMinuteEnding(int value) {
    if (value == 0) return 'минут';
    final remainder10 = value % 10;
    final remainder100 = value % 100;
    
    if (remainder100 >= 11 && remainder100 <= 19) {
      return 'минут';
    }
    if (remainder10 == 1) {
      return 'минуту';
    }
    if (remainder10 >= 2 && remainder10 <= 4) {
      return 'минуты';
    }
    return 'минут';
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
