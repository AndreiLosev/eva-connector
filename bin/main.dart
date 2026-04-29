import 'package:eva_connector/cron_decoder.dart';

void main(List<String> arguments) async {
  final cd = CronDecoder();
  print(cd.decodeDetailed('0 0 12 ? * TUE *'));
}
