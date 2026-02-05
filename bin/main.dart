import 'dart:io';

import 'package:eva_connector/eva_connector.dart';

void main(List<String> arguments) async {
  final c = Configurator.short();
  final s = File(
    '/home/andrei/documents/second scada project/build/back-config.yaml',
  ).readAsStringSync();
  final (_, svc) = c.loadConfig(s);

  print(svc.first.toMap());
}
