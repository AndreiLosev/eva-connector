import 'dart:io';

import 'package:eva_connector/eva_connector.dart';

void main(List<String> arguments) async {
  final x = {'xx': 123, 'yyy': 'wasa11'};

  print({'yyy': 333, ...x});
}
