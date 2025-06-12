class TestResponse {
  bool active;
  int bootId;
  int build;
  int eapiVersion;
  bool instantSave;
  int pid;
  String productCode;
  String productName;
  String systemName;
  double time;
  double uptime;
  String version;
  int workers;

  TestResponse({
    required this.active,
    required this.bootId,
    required this.build,
    required this.eapiVersion,
    required this.instantSave,
    required this.pid,
    required this.productCode,
    required this.productName,
    required this.systemName,
    required this.time,
    required this.uptime,
    required this.version,
    required this.workers,
  });

  factory TestResponse.fromMap(Map<dynamic, dynamic> json) {
    return TestResponse(
      active: json['active'],
      bootId: json['boot_id'],
      build: json['build'],
      eapiVersion: json['eapi_version'],
      instantSave: json['instant_save'],
      pid: json['pid'],
      productCode: json['product_code'],
      productName: json['product_name'],
      systemName: json['system_name'],
      time: json['time'],
      uptime: json['uptime'],
      version: json['version'],
      workers: json['workers'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'active': active,
      'boot_id': bootId,
      'build': build,
      'eapi_version': eapiVersion,
      'instant_save': instantSave,
      'pid': pid,
      'product_code': productCode,
      'product_name': productName,
      'system_name': systemName,
      'time': time,
      'uptime': uptime,
      'version': version,
      'workers': workers,
    };
  }
}

