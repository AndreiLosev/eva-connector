import 'package:eva_connector/src/eva-config/svcs/hmi_service/api.dart';
import 'package:eva_connector/src/eva-config/svcs/hmi_service/session.dart';
import 'package:eva_connector/src/eva-config/svcs/hmi_service/user_data.dart';
import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class HmiConfig extends ISvcConfig {
  List<Api> api = [];
  String? db;
  String? apiFilter;
  List<String> authSvcs = ['eva.aaa.localauth'];
  Session session = Session();
  UserData userData = UserData();
  int keepApiLog = 86400;
  bool publicApiLog = true;
  String uiPath = "ui";
  bool uiNotFoundToBase = true;
  String pvtPath = "pvt";
  String? pvtUserDirs;
  String? defaultHistoryDbSvc;
  String mimeTypes = "share/mime.yml";
  int bufSize = 16384;
  bool development = true;
  String? wsUri;

  @override
  void loadFromMap(Map map) {
    api.addAll((map['api'] as List).map((e) => Api()..loadFromMap(e)));
    db = map['db'] as String?;
    apiFilter = map['api_filter'] as String?;
    authSvcs.clear();
    authSvcs.addAll((map['auth_svcs'] as List).cast<String>());
    session.loadFromMap(map['session'] as Map);
    userData.loadFromMap(map['user_data'] as Map);
    keepApiLog = map['keep_api_log'] as int;
    publicApiLog = map['public_api_log'] as bool;
    uiPath = map['ui_path'] as String;
    uiNotFoundToBase = map['ui_not_found_to_base'] ?? true;
    pvtPath = map['pvt_path'] as String;
    pvtUserDirs = map['pvt_user_dirs'] as String?;
    defaultHistoryDbSvc = map['default_history_db_svc'] as String?;
    mimeTypes = map['mime_types'] as String;
    bufSize = map['buf_size'] as int;
    development = map['development'] ?? false;
    wsUri = map['ws_uri'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'api': api.map((e) => e.toMap()),
      if (db != null) 'db': db,
      if (apiFilter != null) 'api_filter': apiFilter,
      'auth_svcs': authSvcs,
      'session': session.toMap(),
      'user_data': userData.toMap(),
      'keep_api_log': keepApiLog,
      'public_api_log': publicApiLog,
      'ui_path': uiPath,
      'ui_not_found_to_base': uiNotFoundToBase,
      'pvt_path': pvtPath,
      if (pvtUserDirs != null) 'pvt_user_dirs': pvtUserDirs,
      if (defaultHistoryDbSvc != null)
        'default_history_db_svc': defaultHistoryDbSvc,
      'mime_types': mimeTypes,
      'buf_size': bufSize,
      'development': development,
      'ws_uri': wsUri,
    };
  }
}
