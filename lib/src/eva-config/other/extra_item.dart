enum AdditionalFunctions { sleep, system }

sealed class ExtraItem {
  final bool ignoereError;

  ExtraItem(this.ignoereError);

  Map<String, dynamic> toConfig();
}

class EvaExtraItem extends ExtraItem {
  final String method;
  final Map<String, dynamic> params;

  EvaExtraItem(this.method, this.params, super.ignoereError);

  @override
  Map<String, dynamic> toConfig() => {
    'method': method,
    'params': params,
    '_pass': ignoereError,
  };
}

class OtherExtraItem extends ExtraItem {
  final AdditionalFunctions function;
  final List<Object> args;

  OtherExtraItem(this.function, this.args, super.ignoereError);

  @override
  Map<String, dynamic> toConfig() => {
    'function': function.name,
    'args': args,
    '_pass': ignoereError,
  };
}
