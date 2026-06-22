enum AdditionalFunctions { sleep, system }

sealed class ExtraItem {
  final bool ignoereError;

  ExtraItem(this.ignoereError);

  Map<String, dynamic> toConfig();

  static ExtraItem fromConfig(Map map) {
    if (map['method'] is String) {
      return EvaExtraItem(map['method'], map['params'], map['_pass']);
    } else if (map['function'] == AdditionalFunctions.sleep.name) {
      return OtherExtraItem(
        AdditionalFunctions.sleep,
        map['args'],
        map['_pass'],
      );
    } else if (map['function'] == AdditionalFunctions.system.name) {
      return OtherExtraItem(
        AdditionalFunctions.system,
        map['args'],
        map['_pass'],
      );
    }

    throw Exception('invalide params for create ExtraItem: $map');
  }
}

class EvaExtraItem extends ExtraItem {
  final String method;
  final Map<String, dynamic>? params;

  EvaExtraItem(this.method, this.params, super.ignoereError);

  @override
  Map<String, dynamic> toConfig() => {
    'method': method,
    'params': ?params,
    '_pass': ?(ignoereError ? ignoereError : null),
  };
}

class OtherExtraItem extends ExtraItem {
  final AdditionalFunctions function;
  final List<Object>? args;

  OtherExtraItem(this.function, this.args, super.ignoereError);

  @override
  Map<String, dynamic> toConfig() => {
    'function': function.name,
    'args': ?args,
    '_pass': ?(ignoereError ? ignoereError : null),
  };
}
