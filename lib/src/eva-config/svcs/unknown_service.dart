import 'package:eva_connector/eva_connector.dart';

class UnknownService extends BaseSvc<UnknownConfig> {
  static const svcCommand = "eva svc list";

  UnknownService(String id)
    : super(id, UnknownService.svcCommand, UnknownConfig());
}

class UnknownConfig extends ISvcConfig {
  Map<String, dynamic> data = {};

  @override
  void loadFromMap(Map map) {
    data = map.cast();
  }

  @override
  Map<String, dynamic> toMap() => data;
}
