import 'package:eva_connector/src/eva-config/svcs/hmi_service/api.dart';
import 'package:eva_connector/src/eva-config/svcs/hmi_service/oidc_config.dart';
import 'package:eva_connector/src/eva-config/svcs/hmi_service/session.dart';
import 'package:eva_connector/src/eva-config/svcs/hmi_service/user_data.dart';
import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class HmiConfig extends ISvcConfig {
  List<Api> api = [];
  String? db;
  String? apiFilter;
  List<String> authSvcs = ['eva.aaa.localauth'];
  OidcConfig? oidc;
  Session session = Session();
  UserData userData = UserData();
  int keepApiLog = 86400;
  bool? publicApiLog = true;
  List<String>? oids;
  List<String>? oidsExclude;
  String uiPath = "ui";
  bool uiNotFoundToBase = true;
  String pvtPath = "pvt";
  String? pvtUserDirs;
  String? defaultHistoryDbSvc;
  String mimeTypes = "share/mime.yml";
  int bufSize = 16384;
  bool development = true;
  bool? demo;
  bool? vendoredApps;
  String? wsUri;

  @override
  void loadFromMap(Map map) {
    api.addAll((map['api'] as List).map((e) => Api()..loadFromMap(e)));
    db = map['db'] as String?;
    apiFilter = map['api_filter'] as String?;
    authSvcs.clear();
    authSvcs.addAll((map['auth_svcs'] as List).cast<String>());
    if (map['oidc'] != null) {
      oidc = OidcConfig()..loadFromMap(map['oidc'] as Map);
    }
    session.loadFromMap(map['session'] as Map);
    userData.loadFromMap(map['user_data'] as Map);
    keepApiLog = map['keep_api_log'] as int;
    publicApiLog = map['public_api_log'] as bool?;
    oids = (map['oids'] as List?)?.cast<String>();
    oidsExclude = (map['oids_exclude'] as List?)?.cast<String>();
    uiPath = map['ui_path'] as String;
    uiNotFoundToBase = map['ui_not_found_to_base'] ?? true;
    pvtPath = map['pvt_path'] as String;
    pvtUserDirs = map['pvt_user_dirs'] as String?;
    defaultHistoryDbSvc = map['default_history_db_svc'] as String?;
    mimeTypes = map['mime_types'] as String;
    bufSize = map['buf_size'] as int;
    development = map['development'] ?? true;
    demo = map['demo'] as bool?;
    vendoredApps = map['vendored_apps'] as bool?;
    wsUri = map['ws_uri'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'api': api.map((e) => e.toMap()).toList(),
      if (db != null) 'db': db,
      if (apiFilter != null) 'api_filter': apiFilter,
      'auth_svcs': authSvcs,
      if (oidc != null) 'oidc': oidc!.toMap(),
      'session': session.toMap(),
      'user_data': userData.toMap(),
      'keep_api_log': keepApiLog,
      if (publicApiLog != null) 'public_api_log': publicApiLog,
      if (oids != null) 'oids': oids,
      if (oidsExclude != null) 'oids_exclude': oidsExclude,
      'ui_path': uiPath,
      'ui_not_found_to_base': uiNotFoundToBase,
      'pvt_path': pvtPath,
      if (pvtUserDirs != null) 'pvt_user_dirs': pvtUserDirs,
      if (defaultHistoryDbSvc != null)
        'default_history_db_svc': defaultHistoryDbSvc,
      'mime_types': mimeTypes,
      'buf_size': bufSize,
      'development': development,
      if (demo != null) 'demo': demo,
      if (vendoredApps != null) 'vendored_apps': vendoredApps,
      'ws_uri': wsUri,
    };
  }
}
