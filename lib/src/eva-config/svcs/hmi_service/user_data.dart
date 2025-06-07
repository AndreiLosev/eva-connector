import 'package:eva_connector/src/eva-config/serializable.dart';

class UserData implements Serializable {
  int maxRecords = 100;
  int maxRecordLength = 16384;

  @override
  Map<String, dynamic> toMap() {
    return {'max_records': maxRecords, 'max_record_length': maxRecordLength};
  }

  @override
  void loadFromMap(Map map) {
    maxRecords = map['max_records'] as int;
    maxRecordLength = map['max_record_length'] as int;
  }
}
