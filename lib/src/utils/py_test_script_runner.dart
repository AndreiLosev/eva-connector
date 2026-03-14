import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:busrt_client/busrt_client.dart';
import 'package:eva_connector/eva_connector.dart' show Lmacro, RpcClient;
import 'package:eva_connector/src/utils/action_status.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

class PyTestScriptRunner {
  static const testSvcName = 'py.macroses.test';

  final String _binPath;
  final String _workDir;

  final _subscibers = <StreamSubscription<List<int>>>[];

  late Completer<String> _completer;
  Timer? _timeout;

  final _outBuffer = StringBuffer();

  PyTestScriptRunner(String binPath, String workDir)
    : _binPath = binPath,
      _workDir = workDir;

  Future<String> run(
    RpcClient client,
    String svcId,
    Lmacro lmacro, {
    Map<String, dynamic> cvars = const {},
    Duration timeout = const Duration(seconds: 15),
  }) async {
    Process? process;
    String result;
    try {
      process = await _runTestSvc(svcId, cvars);
      await _runMacros(client, lmacro);
      result = await _wait(timeout, process);
    } finally {
      await _clear(process);
    }

    final out = _outBuffer.toString();
    _outBuffer.clear();
    return "$result:${Platform.lineTerminator}$out";
  }

  Future<void> _clear(Process? process) async {
    await Future.delayed(const Duration(milliseconds: 250));
    process?.kill();
    _timeout?.cancel();
  }

  Future<String> _wait(Duration timeout, Process process) async {
    _timeout = Timer(timeout, () {
      _completer.complete('timeout');
    });
    final result = await _completer.future;
    process.stdin.add([233]);

    for (var e in _subscibers) {
      e.cancel();
    }

    return result;
  }

  Future<void> _runMacros(RpcClient client, Lmacro lmacro) async {
    final path = lmacro.oid.replaceFirst(':', '/');
    client.subscribe('ACT/$path', _onActionFrane);

    for (var t in ['trace', 'debug', 'info', 'warn', 'error']) {
      client.subscribe('LOG/IN/$t', _onLogFrane);
    }
    await client.runToSvc(testSvcName, lmacro);
  }

  Future<Process> _runTestSvc(String svcId, Map<String, dynamic>? cvars) async {
    final process = await Process.start(_binPath, []);

    _completer = Completer();
    _subscibers.add(
      process.stdout.listen((e) {
        _completer.complete(utf8.decode(e));
      }),
    );

    _subscibers.add(
      process.stderr.listen((e) {
        _completer.complete(utf8.decode(e));
      }),
    );

    process.stdin.add([1]);
    final configBin = serialize(_getConfig(svcId, cvars));
    final configLength = ByteData(4);
    configLength.setUint32(0, configBin.length, Endian.little);
    process.stdin.add(configLength.buffer.asUint8List());
    process.stdin.add(configBin);
    await _completer.future;
    _completer = Completer();
    return process;
  }

  void _onLogFrane(Frame f) {
    if (f.payload.isEmpty) return;
    if (f.sender != testSvcName) return;
    final message = utf8
        .decode(f.payload)
        .replaceFirst(RegExp(r'mod:macro_api.*::'), '');
    final start = f.topic?.replaceFirst('LOG/IN/', '') ?? '';
    _outBuffer.writeln("$start [${DateTime.now()}]: $message");
  }

  void _onActionFrane(Frame f) {
    if (f.sender != testSvcName && f.payload.isEmpty) return;
    final data = deserialize(f.payload);
    final text = {
      if (data['status'] is int)
        'status': (data['status'] as int).toActionsStatus().name,
      if (data['out'] != null) 'out': data['out'],
      if (data['exitcode'] != null) 'exitcode': data['exitcode'],
      if (data['t'] != null)
        't': data['t']
      else
        't_local': DateTime.now().toIso8601String(),
    };
    final js = JsonEncoder.withIndent('  ');
    _outBuffer.writeln(js.convert(text));
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
