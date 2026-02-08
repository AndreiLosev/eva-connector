import 'package:eva_connector/eva_connector.dart';

void main(List<String> args) {
  final x = {"1": 'wasa', "2": "pety"};

  final x1 = YamlWriter().write(x);

  print(x1);
}
