import 'package:eva_connector/src/eva-config/items/item.dart';
import 'package:eva_connector/src/exceptions/base_exception.dart';

sealed class InvalidEntity extends BaseException {
  InvalidEntity([super.message]);
}

class InvalidOid extends InvalidEntity {
  InvalidOid(String oid) : super("Invalid Oid: $oid");

  static void checkOid(String oid) {
    final regexp = RegExp(
      "(${Sensor.name}|${Unit.name}|${Lvar.name}|${Lmacro.name})(:|/)",
    );
    if (oid.startsWith(regexp)) {
      return;
    }

    throw InvalidOid(oid);
  }
}
