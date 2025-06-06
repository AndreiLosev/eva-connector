class Condition {
  num? min;
  num? max;
  bool minEq = false;
  bool maxEq = false;
  String? expression;

  Condition();

  Map<String, dynamic> toMap() {
    if (expression != null) {
      return {'expression': expression};
    }
    return {
      if (min != null) 'min': min,
      if (max != null) 'max': max,
      'min_eq': minEq,
      'max_eq': maxEq,
    };
  }

  void loadFromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    if (map.containsKey('expression')) {
      expression = map['expression'] as String?;
    } else {
      min = map['min'] as num?;
      max = map['max'] as num?;
      minEq = map['min_eq'] as bool? ?? false;
      maxEq = map['max_eq'] as bool? ?? false;
    }
  }
}
