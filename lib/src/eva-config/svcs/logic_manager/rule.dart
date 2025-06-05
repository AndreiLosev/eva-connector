import 'package:eva_connector/src/eva-config/svcs/logic_manager/condition.dart';

class Rule {
  String id;
  String oid = '';
  Prop prop = Prop.status;
  Condition condition = Condition();
  bool? breakOnMatch = false;
  int? chilloutTime = 0;
  String run;
  String? initial = 'process';
  bool? block = false;
  int? bit;
  List<dynamic>? args = [];
  Map<String, dynamic>? kwargs = {};

  Rule(this.id, this.run);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        map[key] = value;
      }
    }

    addIfNotNull('id', id);
    addIfNotNull('oid', oid);
    addIfNotNull('prop', prop.name);
    addIfNotNull('condition', condition.toMap());
    addIfNotNull('break', breakOnMatch);
    addIfNotNull('chillout_time', chilloutTime);
    addIfNotNull('run', run);
    addIfNotNull('initial', initial);
    addIfNotNull('block', block);
    addIfNotNull('bit', bit);
    addIfNotNull('args', args);
    addIfNotNull('kwargs', kwargs);

    return map;
  }

  void loadFromMap(Map<String, dynamic> map) {
    id = map['id'];
    oid = map['oid'];
    prop = Prop.fromString(map['prop']);
    condition.loadFromMap(map['condition']);
    breakOnMatch = map['break'];
    chilloutTime = map['chillout_time'];
    run = map['run'];
    initial = map['initial'];
    block = map['block'];
    bit = map['bit'] as int?;
    args = map['args'];
    kwargs = map['kwargs'];
  }
}

enum Prop {
  status,
  value,
  act;

  static Prop fromString(String str) {
    return switch (str) {
      'status' => Prop.status,
      'value' => Prop.value,
      'act' => Prop.act,
      _ => throw Exception("invalid prop: $str"),
    };
  }
}
