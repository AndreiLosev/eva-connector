import 'dart:io';

import 'package:eva_connector/eva_connector.dart';

void main(List<String> args) {
  final c = Configurator.short();
  final (_, s) = c.loadConfig(
    File(
      '/home/andrei/documents/second scada project/build/back-config.yaml',
    ).readAsStringSync(),
  );

  print(s.first.toMap());
}
