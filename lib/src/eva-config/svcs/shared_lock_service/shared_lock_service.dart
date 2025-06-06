import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/shared_lock_service/shared_lock_config.dart';

class SharedLockService extends BaseSvc<SharedLockConfig> {
  static const svcCommand = "svc/eva-svc-locker";

  SharedLockService(String id)
    : super(id, SharedLockService.svcCommand, SharedLockConfig());
}
