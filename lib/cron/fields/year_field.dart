// SPDX-License-Identifier: MIT

import 'cron_field.dart';

/// Year field (any year, typically 1970-2099 or similar range)
class YearField extends CronField {
  // Reasonable default range for years
  static const int defaultMinYear = 1970;
  static const int defaultMaxYear = 2099;

  YearField(String value) : super(value, defaultMinYear, defaultMaxYear);

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
      return 'каждый год';
    }
    if (isSpecific) {
      return 'в ${specificValue} году';
    }
    
    // Handle step expressions
    if (rawValue.contains('/')) {
      final parts = rawValue.split('/');
      if (parts[0] == '*' && parts.length == 2) {
        final step = int.tryParse(parts[1]) ?? 1;
        return 'каждые $step ${_getYearEnding(step)}';
      }
    }
    
    // Handle ranges
    if (rawValue.contains('-')) {
      return 'с ${resolvedValues.first} по ${resolvedValues.last} год';
    }
    
    // Handle lists
    if (rawValue.contains(',')) {
      return 'в ${resolvedValues.join(", ")} годах';
    }
    
    return 'в ${resolvedValues.join(", ")} годах';
  }

  String _getYearEnding(int value) {
    if (value == 1) return 'год';
    if (value >= 2 && value <= 4) return 'года';
    return 'лет';
  }
}

/// Parse helper
List<int> _parseField(String value, int min, int max) {
  if (value == '*' || value == '?') {
    // For year field, "any" typically means every year
    // But we can't generate all years, so we return a special marker
    return [0]; // 0 means "any year"
  }
  
  if (value.contains('/')) {
    final parts = value.split('/');
    final base = parts[0];
    final step = int.tryParse(parts[1]) ?? 1;
    
    if (base == '*') {
      // Generate years with step from current year
      // This is a bit tricky - we'll generate a reasonable range
      final currentYear = DateTime.now().year;
      final result = <int>[];
      for (var i = currentYear; i <= currentYear + 100; i += step) {
        if (i >= min && i <= max) {
          result.add(i);
        }
      }
      return result;
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
  
  // Try to parse as number
  final numValue = int.tryParse(value);
  if (numValue != null) {
    // Accept any year number
    return [numValue];
  }
  
  return [DateTime.now().year]; // Default to current year
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
