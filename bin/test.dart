import 'package:eva_connector/eva_connector.dart';

void main(List<String> args) {
  final rx = RegExp(
    "(${Sensor.name}|${Unit.name}|${Lvar.name}|${Lmacro.name}):",
  );

  final x = "sensor:test/value/test";
  final m = rx.matchAsPrefix(x);

  print([
    x.substring(m![0]!.length),
    m![0]!.substring(0, m[0]!.length - 1),
    x.replaceFirst(rx, '').split('/'),
    'wasa'.split('/'),
  ]);
}
