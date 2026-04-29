// SPDX-License-Identifier: MIT

/// Abstract base class for a cron field
abstract class CronField {
  final String rawValue;
  final int minValue;
  final int maxValue;
  
  /// Resolved values that this field represents
  List<int> resolvedValues = [];
  
  /// Human-readable description in Russian
  String humanReadable = '';

  CronField(this.rawValue, this.minValue, this.maxValue);

  /// Parse the field value and populate resolvedValues and humanReadable
  void parse();

  /// Get all possible values this field can match
  List<int> getValues();

  /// Check if this field matches "any" (wildcard *)
  bool get isAny => rawValue == '*' || resolvedValues.length == (maxValue - minValue + 1);

  /// Check if this field is a single specific value
  bool get isSpecific => resolvedValues.length == 1;

  /// Get the single value if isSpecific, otherwise null
  int? get specificValue => isSpecific ? resolvedValues.first : null;

  /// Get human-readable description
  String toHumanReadable();
}
