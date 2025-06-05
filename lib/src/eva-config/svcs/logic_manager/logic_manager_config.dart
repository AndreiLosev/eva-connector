import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';
import 'package:eva_connector/src/eva-config/svcs/logic_manager/cycle.dart';
import 'package:eva_connector/src/eva-config/svcs/logic_manager/jobs.dart';
import 'package:eva_connector/src/eva-config/svcs/logic_manager/opener.dart';
import 'package:eva_connector/src/eva-config/svcs/logic_manager/rule.dart';

class LogicManagerConfig extends ISvcConfig {
  List<Rule> rules = [];
  List<Cycle> cycles = [];
  List<Job> jobs = [];
  List<Opener> openers = [];

  LogicManagerConfig();

  @override
  Map<String, dynamic> toMap() {
    return {
      'rules': rules.map((e) => e.toMap()).toList(),
      'cycles': cycles.map((e) => e.toMap()).toList(),
      'jobs': jobs.map((e) => e.toMap()).toList(),
      'openers': openers.map((e) => e.toMap()).toList(),
    };
  }

  @override
  void loadFromMap(Map map) {
    rules =
        (map['rules'] as List<dynamic>?)
            ?.where((e) => e['id'] is String && e['run'] is String)
            .map(
              (e) =>
                  Rule(e['id'], e['run'])
                    ..loadFromMap(e as Map<String, dynamic>),
            )
            .toList() ??
        [];
    cycles =
        (map['cycles'] as List<dynamic>?)
            ?.where((e) => e['id'] is String && e['run'] is String)
            .map(
              (e) =>
                  Cycle(e['id'], e['run'])
                    ..loadFromMap(e as Map<String, dynamic>),
            )
            .toList() ??
        [];
    jobs =
        (map['jobs'] as List<dynamic>?)
            ?.where((e) => e['id'] is String && e['run'] is String)
            .map(
              (e) =>
                  Job(e['id'], e['run'])
                    ..loadFromMap(e as Map<String, dynamic>),
            )
            .toList() ??
        [];
    openers =
        (map['openers'] as List<dynamic>?)
            ?.where((e) => e['oid'])
            .map(
              (e) => Opener(e['oid'])..loadFromMap(e as Map<String, dynamic>),
            )
            .toList() ??
        [];
  }
}
