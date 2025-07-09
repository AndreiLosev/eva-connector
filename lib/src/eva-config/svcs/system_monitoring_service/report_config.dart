import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/blk_config.dart';
import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/disk_config.dart';
import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/exe_config.dart';
import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/network_config.dart';
import 'package:eva_connector/src/eva-config/svcs/system_monitoring_service/system_report_config.dart';

class ReportConfig {
  String oidPrefix = '';
  SystemReportConfig system = SystemReportConfig();
  SystemReportConfig cpu = SystemReportConfig();
  SystemReportConfig loadAvg = SystemReportConfig();
  SystemReportConfig memory = SystemReportConfig();
  DisksConfig disks = DisksConfig();
  BlkConfig blk = BlkConfig();
  NetworkConfig network = NetworkConfig();
  ExeConfig exe = ExeConfig();

  ReportConfig();

  ReportConfig.fromMap(Map<String, dynamic> map) {
    oidPrefix = map['oid_prefix'] ?? '';
    system = SystemReportConfig.fromMap(map['system'] as Map<String, dynamic>);
    cpu = SystemReportConfig.fromMap(map['cpu'] as Map<String, dynamic>);
    loadAvg = SystemReportConfig.fromMap(
      map['load_avg'] as Map<String, dynamic>,
    );
    memory = SystemReportConfig.fromMap(map['memory'] as Map<String, dynamic>);
    disks = DisksConfig.fromMap(map['disks'] as Map<String, dynamic>);
    blk = BlkConfig.fromMap(map['blk'] as Map<String, dynamic>);
    network = NetworkConfig.fromMap(map['network'] as Map<String, dynamic>);
    exe = ExeConfig.fromMap(map['exe'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toMap() => {
    'oid_prefix': oidPrefix,
    'system': system.toMap(),
    'cpu': cpu.toMap(),
    'load_avg': loadAvg.toMap(),
    'memory': memory.toMap(),
    'disks': disks.toMap(),
    'blk': blk.toMap(),
    'network': network.toMap(),
    'exe': exe.toMap(),
  };
}
