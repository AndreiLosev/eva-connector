import 'package:eva_connector/src/Configs/config.dart';
import 'package:eva_connector/src/rpc/eva_client.dart';

void main(List<String> args) async {
  print([
    DateTime.now().millisecondsSinceEpoch,
    DateTime.now().toUtc().millisecondsSinceEpoch,
    DateTime.now().millisecondsSinceEpoch ==
        DateTime.now().toUtc().millisecondsSinceEpoch,
  ]);
}
