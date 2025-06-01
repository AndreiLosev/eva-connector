import 'package:eva_connector/src/exceptions/base_exception.dart';

class OidIsEmptyExeption extends BaseException {
  OidIsEmptyExeption([
    super.message = "an element without an oid cannot exist",
  ]);
}
