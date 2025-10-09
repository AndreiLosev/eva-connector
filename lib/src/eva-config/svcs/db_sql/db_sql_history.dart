import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/db_sql/db_sql_config.dart';

class DbSqlHistory extends BaseSvc<DbSqlConfig> {
  static const svcCommand = "svc/eva-db-timescale";
  DbSqlHistory(String id) : super(id, DbSqlHistory.svcCommand, DbSqlConfig());
}
