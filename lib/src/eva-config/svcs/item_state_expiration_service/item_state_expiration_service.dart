import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/item_state_expiration_service/item_state_expiration_config.dart';

class ItemStateExpirationService extends BaseSvc<ItemStateExpirationConfig> {
  static const svcCommand = "svc/eva-svc-expiration";
  ItemStateExpirationService(String oid)
    : super(
        oid,
        ItemStateExpirationService.svcCommand,
        ItemStateExpirationConfig(),
      );
}
