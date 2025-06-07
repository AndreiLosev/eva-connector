import 'package:eva_connector/src/eva-config/svcs/hmi_service/api.dart';
import 'package:eva_connector/src/eva-config/svcs/hmi_service/session.dart';
import 'package:eva_connector/src/eva-config/svcs/hmi_service/user_data.dart';
import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class HmiConfig extends ISvcConfig {
  Api api = Api();
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
  bool demo = true;
  bool vendoredApps = true;
  String wsUri = '/ws';

  @override
  void loadFromMap(Map map) {
    final config = map['config'] as Map<String, dynamic>;

    api.loadFromMap(config['api'] as Map);
    db = config['db'] as String?;
    apiFilter = config['api_filter'] as String?;
    authSvcs.clear();
    authSvcs.addAll((config['auth_svcs'] as List).cast<String>());
    session.loadFromMap(config['session'] as Map);
    userData.loadFromMap(config['user_data'] as Map);
    keepApiLog = config['keep_api_log'] as int;
    publicApiLog = config['public_api_log'] as bool;
    uiPath = config['ui_path'] as String;
    uiNotFoundToBase = config['ui_not_found_to_base'] as bool;
    pvtPath = config['pvt_path'] as String;
    pvtUserDirs = config['pvt_user_dirs'] as String?;
    defaultHistoryDbSvc = config['default_history_db_svc'] as String?;
    mimeTypes = config['mime_types'] as String;
    bufSize = config['buf_size'] as int;
    development = config['development'] as bool;
    demo = config['demo'] as bool;
    vendoredApps = config['vendored_apps'] as bool;
    wsUri = config['ws_uri'] as String;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'api': api.toMap(),
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
      'demo': demo,
      'vendored_apps': vendoredApps,
      'ws_uri': wsUri,
    };
  }
}
