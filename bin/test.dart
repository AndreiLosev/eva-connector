import 'dart:convert';

import 'package:msgpack_dart/msgpack_dart.dart';

void main(List<String> args) {
  final x = (15, 'wasa', 33.44);
  print(serialize(x));
}
