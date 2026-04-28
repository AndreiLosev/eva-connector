void main(List<String> arguments) async {
  final str = "20 <= x < 100";
  final str1 = 'x > 3';
  final str2 = "x = -1";
  final str3 = "x >= 8";
  final str4 = "100 => x > 20";

  print(Range.fromStr(str));
  print(Range.fromStr(str1));
  print(Range.fromStr(str2));
  print(Range.fromStr(str3));
  print(Range.fromStr(str4));
}

class Range {
  final double? min;
  final double? max;
  final bool minEq;
  final bool maxEq;

  Range({this.min, this.max, this.minEq = false, this.maxEq = false});

  @override
  String toString() {
    return {'min': min, 'max': max, 'minEq': minEq, 'maxEq': maxEq}.toString();
  }

  factory Range.defaultRange() {
    return Range();
  }

  factory Range.fromStr(String s) {
    final condition = s.trim();
    if (condition.isEmpty || condition == "*" || condition == "#") {
      return Range.defaultRange();
    } else {
      double? rInspectedMin;
      double? rInspectedMax;
      bool rInspectedMinEq = false;
      bool rInspectedMaxEq = false;

      var c = condition
          .trim()
          .replaceAll(' ', "")
          .replaceAll(">=", "}")
          .replaceAll("=>", "}")
          .replaceAll("<=", "{")
          .replaceAll("=<", "{")
          .replaceAll("===", "=")
          .replaceAll("==", "=");

      final vals = c.split(RegExp(r'[<>{}=]'));

      if (vals.length > 3) {
        throw Exception("Не верные данные");
      }

      if (vals.length > 1) {
        for (int i = 0; i < vals.length; i++) {
          final v = vals[i];
          if (v == "x" || v == "X") {
            if (vals.length == 2) {
              if (i > 1) {
                throw Exception("Не верные данные");
              }
              final s = c.codeUnitAt(vals[0].length);
              final sChar = String.fromCharCode(s);
              if (sChar == '=') {
                rInspectedMin = double.tryParse(vals[1 - i]);
                rInspectedMax = rInspectedMin;
                rInspectedMinEq = true;
                rInspectedMaxEq = true;
              } else if (((sChar == '}' || sChar == '>') && i == 0) ||
                  ((sChar == '{' || sChar == '<') && i == 1)) {
                rInspectedMin = double.tryParse(vals[1 - i]);
                rInspectedMinEq = sChar == '}' || sChar == '{';
              } else if (((sChar == '}' || sChar == '>') && i == 1) ||
                  ((sChar == '{' || sChar == '<') && i == 0)) {
                rInspectedMax = double.tryParse(vals[1 - i]);
                rInspectedMaxEq = sChar == '}' || sChar == '{';
              }
            } else if (vals.length == 3) {
              if (i != 1) {
                throw Exception("Не верные данные");
              }
              final s1 = c.codeUnitAt(vals[0].length);
              final s1Char = String.fromCharCode(s1);
              final s2 = c.codeUnitAt(vals[0].length + 2);
              final s2Char = String.fromCharCode(s2);

              if (s2Char == '}' || s2Char == '>') {
                rInspectedMax = double.tryParse(vals[i - 1]);
                rInspectedMaxEq = s1Char == '}';
                rInspectedMin = double.tryParse(vals[i + 1]);
                rInspectedMinEq = s2Char == '}';
              } else if (s2Char == '{' || s2Char == '<') {
                rInspectedMin = double.tryParse(vals[i - 1]);
                rInspectedMinEq = s1Char == '{';
                rInspectedMax = double.tryParse(vals[i + 1]);
                rInspectedMaxEq = s2Char == '{';
              }
              if (rInspectedMax! <= rInspectedMin!) {
                throw Exception("Не верные данные");
              }
            }
            break;
          }
        }
      } else {
        throw Exception("Не верные данные");
      }

      return Range(
        min: rInspectedMin,
        max: rInspectedMax,
        minEq: rInspectedMinEq,
        maxEq: rInspectedMaxEq,
      );
    }
  }
}
