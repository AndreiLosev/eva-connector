import 'package:eva_connector/src/eva-config/serializable.dart';

class OidcConfig implements Serializable {
  String? header;
  String? subField;
  String? key;
  int? refresh;
  int? retry;
  int? failedAfter;

  @override
  Map<String, dynamic> toMap() {
    return {
      if (header != null) 'header': header,
      if (subField != null) 'sub_field': subField,
      if (key != null) 'key': key,
      if (refresh != null) 'refresh': refresh,
      if (retry != null) 'retry': retry,
      if (failedAfter != null) 'failed_after': failedAfter,
    };
  }

  @override
  void loadFromMap(Map map) {
    header = map['header'] as String?;
    subField = map['sub_field'] as String?;
    key = map['key'] as String?;
    refresh = map['refresh'] as int?;
    retry = map['retry'] as int?;
    failedAfter = map['failed_after'] as int?;
  }
}
