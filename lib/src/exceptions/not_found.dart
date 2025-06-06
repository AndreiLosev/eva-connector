import 'package:eva_connector/src/exceptions/base_exception.dart';

sealed class NotFound extends BaseException {
  NotFound([super.message]);
}

class NotFoundItems extends NotFound {
  NotFoundItems(String oid) : super('Not Found Items: $oid');
}

class NotFoundService extends NotFound {
  NotFoundService(String oid) : super('Not Found service: $oid');
}
