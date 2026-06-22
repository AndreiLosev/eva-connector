import 'dart:io';

import 'package:hashlib/hashlib.dart';

void main(List<String> arguments) async {
  final file = await File(
    '/home/andrei/documents/my/eva-connector/pubspec.yaml',
  ).readAsBytes();

  print(sha256.convert(file).hex());
  print(
    '72bc40237f6630a861a30d242d2105322df5cac0d3e5c755f4f84870bebdc807' ==
        sha256.convert(file).hex(),
  );
}
