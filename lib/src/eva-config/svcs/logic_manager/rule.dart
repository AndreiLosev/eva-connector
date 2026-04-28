import 'package:eva_connector/eva_connector.dart';

class Rule {
  String id;
  String oid;
  Prop prop = Prop.value;
  String condition = "x = 1";
  bool? breakOnMatch = false;
  int? chilloutTime = 0;
  String run;
  Initial initial = Initial.process;
  bool? block = false;
  int? bit;
  List<dynamic>? args = [];
  Map<String, dynamic>? kwargs = {};

  Rule(this.id, this.run, this.oid);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        map[key] = value;
      }
    }

    Range.fromStr(condition);

    addIfNotNull('id', id);
    addIfNotNull('oid', oid);
    addIfNotNull('prop', prop.name);
    addIfNotNull('condition', condition);
    addIfNotNull('break', breakOnMatch);
    addIfNotNull('chillout_time', chilloutTime);
    addIfNotNull('run', run);
    addIfNotNull('initial', initial.name);
    addIfNotNull('block', block);
    addIfNotNull('bit', bit);
    addIfNotNull('args', args);
    addIfNotNull('kwargs', kwargs);

    return map;
  }

  void loadFromMap(Map<String, dynamic> map) {
    id = map['id'];
    oid = map['oid'];
    prop = Prop.fromString(map['prop'] ?? prop.name);
    condition = map['condition'];
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

enum Initial { process, skip, only }
