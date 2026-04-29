// SPDX-License-Identifier: MIT

import 'cron_field.dart';

/// Second field (0-59)
class SecondField extends CronField {
  SecondField(String value) : super(value, 0, 59);

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
      return 'каждую секунду';
    }
    if (isSpecific) {
      final v = specificValue!;
      if (v == 0) return 'в 0 секунд';
      return 'в $v секунду${_getSecondEnding(v)}';
    }
    
    // Handle step expressions like */5
    if (rawValue.contains('/')) {
      final parts = rawValue.split('/');
      if (parts[0] == '*' && parts.length == 2) {
        final step = int.tryParse(parts[1]) ?? 1;
        return 'каждые $step ${_getSecondEnding(step)}';
      }
    }
    
    // Handle ranges
    if (rawValue.contains('-')) {
      return 'с $minValue по $maxValue секунды';
    }
    
    // Handle lists
    if (rawValue.contains(',')) {
      return 'в ${resolvedValues.join(", ")} секунды';
    }
    
    return 'в ${resolvedValues.join(", ")} секунды';
  }

  String _getSecondEnding(int value) {
    if (value == 0) return 'у';
    final remainder10 = value % 10;
    final remainder100 = value % 100;
    
    if (remainder100 >= 11 && remainder100 <= 19) {
      return 'секунд';
    }
    if (remainder10 == 1) {
      return 'секунду';
    }
    if (remainder10 >= 2 && remainder10 <= 4) {
      return 'секунды';
    }
    return 'секунд';
  }
}

/// Parse a single field value (supports *, ranges, steps, lists)
List<int> _parseField(String value, int min, int max) {
  final result = <int>[];
  
  if (value == '*' || value == '?') {
    return List.generate(max - min + 1, (i) => min + i);
  }
  
  // Handle step expressions: */step or start-end/step
  if (value.contains('/')) {
    final parts = value.split('/');
    final base = parts[0];
    final stepStr = parts[1];
    final step = int.tryParse(stepStr) ?? 1;
    
    if (base == '*') {
      for (var i = min; i <= max; i += step) {
        result.add(i);
      }
    } else {
      // Parse range first
      final rangeValues = _parseRange(base, min, max);
      for (final v in rangeValues) {
        if (v >= min && v <= max) {
          result.add(v);
        }
      }
      // Apply step to sorted unique values
      result.sort();
      final stepped = <int>[];
      for (var i = 0; i < result.length; i += step) {
        stepped.add(result[i]);
      }
      return stepped;
    }
    return result;
  }
  
  // Handle ranges: start-end
  if (value.contains('-')) {
    return _parseRange(value, min, max);
  }
  
  // Handle lists: value1,value2,value3
  if (value.contains(',')) {
    final parts = value.split(',');
    for (final part in parts) {
      result.addAll(_parseField(part, min, max));
    }
    return result.toSet().toList()..sort();
  }
  
  // Single value
  final numValue = int.tryParse(value);
  if (numValue != null && numValue >= min && numValue <= max) {
    return [numValue];
  }
  
  // Special Quartz expressions (L, W, #) - not typically used in seconds
  // For seconds, L means last second of minute (59)
  if (value == 'L') {
    return [59];
  }
  
  return [min]; // Default
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
