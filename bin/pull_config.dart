import 'package:busrt_client/busrt_client.dart';
import 'package:eva_connector/src/config.dart';
import 'package:eva_connector/src/eva-config/configurator.dart';
import 'package:eva_connector/src/eva-config/factory.dart';
import 'package:eva_connector/src/rpc/eva_client.dart';
import 'package:yaml_writer/yaml_writer.dart';

void main(List<String> args) async {
  final config = Config();
  final bus = Bus(config.ideName);
  await bus.connect(config.evaSoket);
  final rpc = Rpc(bus);
  final c = EvaClient(rpc, Factory());
  final configurator = Configurator(c, config, YamlWriter());
  await configurator.pullAll();
}
