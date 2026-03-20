import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/utils/py_test_script_runner.dart';

void main(List<String> args) async {
  final c = Config()..evaSoket = 'localhost:10001';
  final client = RpcClient.short(c);

  final r = PyTestScriptRunner(
    '/home/andrei/.local/state/eva_ide/eva4-svc-linux',
    '/home/andrei/documents/my/eva_py_macros_test',
  );

  try {
    await client.connect();
    final res = await r.run(client, 'scriot-dir', Lmacro('lmacro:test2'));
    print(res);
  } finally {
    client.disconnect();
  }
}
