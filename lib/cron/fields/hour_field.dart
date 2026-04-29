// SPDX-License-Identifier: MIT

import 'cron_field.dart';

/// Hour field (0-23)
class HourField extends CronField {
  HourField(String value) : super(value, 0, 23);

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
      return 'каждый час';
    }
    if (isSpecific) {
      return 'в ${_formatHour(specificValue!)}';
    }
    
    // Handle step expressions like */6
    if (rawValue.contains('/')) {
      final parts = rawValue.split('/');
      if (parts[0] == '*' && parts.length == 2) {
        final step = int.tryParse(parts[1]) ?? 1;
        return 'каждые $step ${_getHourEnding(step)}';
      }
    }
    
    // Handle ranges
    if (rawValue.contains('-')) {
      return 'с ${_formatHour(resolvedValues.first)} по ${_formatHour(resolvedValues.last)}';
    }
    
    // Handle lists
    if (rawValue.contains(',')) {
      return 'в ${resolvedValues.map((h) => _formatHour(h)).join(", ")}';
    }
    
    return 'в ${resolvedValues.map((h) => _formatHour(h)).join(", ")}';
  }

  String _formatHour(int hour) {
    if (hour == 0) return '0 часов';
    if (hour == 1) return '1 час';
    if (hour >= 2 && hour <= 4) return '$hour часа';
    return '$hour часов';
  }

  String _getHourEnding(int value) {
    if (value == 1) return 'час';
    if (value >= 2 && value <= 4) return 'часа';
    return 'часов';
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
