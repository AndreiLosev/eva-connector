// SPDX-License-Identifier: MIT

import 'cron_expression.dart';

/// Main class for decoding cron expressions to human-readable Russian text
class CronDecoder {
  /// Decode a cron expression to human-readable text
  String decode(String expression) {
    final cron = CronExpression(expression);
    return _buildDescription(cron);
  }

  /// Decode a cron expression with result object
  CronDescription decodeDetailed(String expression) {
    final cron = CronExpression(expression);
    return CronDescription(
      expression: expression,
      description: _buildDescription(cron),
      fields: _buildFieldDescriptions(cron),
    );
  }

  /// Check if an expression is valid
  bool isValid(String expression) => CronExpression.isValid(expression);

  String _buildDescription(CronExpression cron) {
    final segments = <String>[];
    
    // Handle time part (hour:minute:second)
    final timeDescription = _buildTimeDescription(cron);
    if (timeDescription.isNotEmpty) {
      segments.add(timeDescription);
    }
    
    // Handle day/month/weekday part
    final dateDescription = _buildDateDescription(cron);
    if (dateDescription.isNotEmpty) {
      segments.add(dateDescription);
    }
    
    // Handle year part
    final yearDescription = _buildYearDescription(cron);
    if (yearDescription.isNotEmpty && yearDescription != 'каждый год') {
      segments.add(yearDescription);
    }
    
    // Combine segments
    if (segments.length == 1) {
      return segments.first;
    }
    
    // Join with appropriate conjunctions
    return segments.join(' ');
  }

  String _buildTimeDescription(CronExpression cron) {
    final sb = StringBuffer();
    
    // Handle the case where hour is any (wildcard or ?)
    if (cron.hour.isAny || cron.hour.rawValue == '?') {
      // If both minute and second are any
      if ((cron.minute.isAny || cron.minute.rawValue == '?') && 
          (cron.second.isAny || cron.second.rawValue == '?')) {
        return 'каждую секунду';
      }
      // If minute is any but second is specific
      if ((cron.minute.isAny || cron.minute.rawValue == '?') && 
          !(cron.second.isAny || cron.second.rawValue == '?')) {
        return 'каждую минуту ${cron.second.humanReadable}';
      }
      // If second is any but minute is specific
      if (!(cron.minute.isAny || cron.minute.rawValue == '?') && 
          (cron.second.isAny || cron.second.rawValue == '?')) {
        return 'каждую минуту в ${cron.minute.humanReadable}';
      }
      // Both minute and second are specific
      if (!(cron.minute.isAny || cron.minute.rawValue == '?') && 
          !(cron.second.isAny || cron.second.rawValue == '?')) {
        return 'в ${cron.minute.humanReadable} ${cron.second.humanReadable}';
      }
    }
    
    // Hour is specific
    // If both minute and second are any
    if ((cron.minute.isAny || cron.minute.rawValue == '?') && 
        (cron.second.isAny || cron.second.rawValue == '?')) {
      return 'каждый час в ${cron.hour.humanReadable}';
    }
    
    // If minute is any but second is specific
    if ((cron.minute.isAny || cron.minute.rawValue == '?') && 
        !(cron.second.isAny || cron.second.rawValue == '?')) {
      return 'каждый час в ${cron.hour.humanReadable} ${cron.second.humanReadable}';
    }
    
    // If second is any but minute is specific
    if (!(cron.minute.isAny || cron.minute.rawValue == '?') && 
        (cron.second.isAny || cron.second.rawValue == '?')) {
      return 'в ${cron.hour.humanReadable} ${cron.minute.humanReadable}';
    }
    
    // All three are specific
    return 'в ${cron.hour.humanReadable} ${cron.minute.humanReadable} ${cron.second.humanReadable}';
  }

  String _buildDateDescription(CronExpression cron) {
    final parts = <String>[];
    
    // Check if day and month are both "any"
    final dayIsAny = cron.day.isAny || cron.day.rawValue == '?';
    final monthIsAny = cron.month.isAny || cron.month.rawValue == '?';
    final weekdayIsAny = cron.weekday.isAny || cron.weekday.rawValue == '?';
    
    // Handle special case: ? in day or weekday field means "no specific value"
    // In Quartz, either day or weekday can be ?, but not both
    
    // If both day and weekday are specific or have values
    if (!dayIsAny && !weekdayIsAny) {
      // This is ambiguous in Quartz - typically one should be ?
      // We'll describe both
      if (!cron.day.isAny) {
        parts.add(cron.day.humanReadable);
      }
      if (!cron.weekday.isAny) {
        parts.add(cron.weekday.humanReadable);
      }
      return parts.join(' и ');
    }
    
    // If day is specific (and weekday is ? or any)
    if (!dayIsAny && (weekdayIsAny || cron.weekday.rawValue == '?')) {
      if (!cron.month.isAny) {
        return '${cron.day.humanReadable} ${cron.month.humanReadable}';
      }
      return cron.day.humanReadable;
    }
    
    // If weekday is specific (and day is ? or any)
    if (!weekdayIsAny && (dayIsAny || cron.day.rawValue == '?')) {
      return cron.weekday.humanReadable;
    }
    
    // If month is not any
    if (!monthIsAny) {
      return cron.month.humanReadable;
    }
    
    // Everything is any or ?
    if (dayIsAny && monthIsAny && weekdayIsAny) {
      return 'каждый день';
    }
    
    return parts.join(' ');
  }

  String _buildYearDescription(CronExpression cron) {
    if (cron.hasYear) {
      return cron.yearField.humanReadable;
    }
    return 'каждый год';
  }

  Map<String, String> _buildFieldDescriptions(CronExpression cron) {
    return {
      'second': cron.second.humanReadable,
      'minute': cron.minute.humanReadable,
      'hour': cron.hour.humanReadable,
      'day': cron.day.humanReadable,
      'month': cron.month.humanReadable,
      'weekday': cron.weekday.humanReadable,
      'year': cron.yearField.humanReadable,
    };
  }
}

/// Result object for detailed decoding
class CronDescription {
  final String expression;
  final String description;
  final Map<String, String> fields;

  CronDescription({
    required this.expression,
    required this.description,
    required this.fields,
  });

  @override
  String toString() => description;
}
