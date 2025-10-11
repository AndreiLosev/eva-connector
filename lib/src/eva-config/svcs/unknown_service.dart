import 'package:eva_connector/eva_connector.dart';

class UnknownService extends BaseSvc<UnknownConfig> {
  static const svcCommand = "eva svc list";
  UnknownService(String id)
    : super(id, UnknownService.svcCommand, UnknownConfig());
}

class UnknownConfig extends ISvcConfig {
  @override
  void loadFromMap(Map map) {}

  @override
  Map<String, dynamic> toMap() => {};
}
