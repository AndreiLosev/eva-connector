import 'dart:io';
import 'dart:typed_data';

import 'package:eva_connector/eva_connector.dart' show Lmacro, RpcClient;
import 'package:msgpack_dart/msgpack_dart.dart';

class PythonTestScriptRunner {
  static const testSvcName = 'py.macroses.test';

  final String _binPath;
  final String _workDir;
  final RpcClient Function() _getRpcClient;

  PythonTestScriptRunner(
    String binPath,
    String workDir,
    RpcClient Function() getRpcClient,
  ) : _binPath = binPath,
      _workDir = workDir,
      _getRpcClient = getRpcClient;

  Future<void> run(
    String svcId,
    Lmacro lmacro,
    Map<String, dynamic>? cvars,
  ) async {
    Process? process;
    RpcClient? client;
    try {
      process = await _runTestSvc(svcId, cvars);
      client = _getRpcClient();
      await client.connect();
      await client.runToSvc(svcId, lmacro);
      process.stdin.add([233]);
    } finally {
      await client?.disconnect();
      process?.kill();
    }
  }

  Future<Process> _runTestSvc(String svcId, Map<String, dynamic>? cvars) async {
    final process = await Process.start(_binPath, []);

    process.stdin.add([1]);
    final configBin = serialize(_getConfig(svcId, cvars));
    final configLength = ByteData(4);
    configLength.setUint32(0, configBin.length, Endian.little);
    process.stdin.add(configLength.buffer.asUint8List());
    process.stdin.add(configBin);

    return process;
  }

  Map<String, dynamic> _getConfig(String svcId, Map<String, dynamic>? cvars) =>
      {
        'id': testSvcName,
        'system_name': 'pc',
        'version': '4.2.0',
        'command': 'bin/eva4-svc-controller-py',
        'prepare_command': null,
        'data_path': null,
        'timeout': {'startup': 10, 'shutdown': 10, 'default': 10},
        'core': {
          'build': '2026022602',
          'version': '4.2.0',
          'eapi_verion': '1.0.0',
          'path': _workDir,
          'log_level': 0,
          'active': true,
        },
        'bus': {
          'type': 'native',
          'path': "127.0.0.1:10001",
          'timeout': 10,
          'buf_size': 65536,
          'buf_ttl': 65536,
          'queue_size': 65536,
        },
        'config': {'macro_dir': svcId, 'cvars': cvars},
        'workers': 1,
        'reactToFail': true,
        'fips': false,
        'user': 'nobody',
        'callTracing': true,
      };
}
