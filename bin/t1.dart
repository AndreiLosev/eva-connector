import 'dart:io';

import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/eva-config/factory.dart';

void main(List<String> args) async {
  final configurator = Configurator(YamlWriter(), Factory());
  final (_, s) = configurator.loadConfig(
    File(
      '/home/andrei/documents/ScadaProjects/build/back-config.yaml',
    ).readAsStringSync(),
  );

  s.map((e) => e.toMap()).forEach(print);
}
