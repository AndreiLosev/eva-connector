import 'package:eva_connector/eva_connector.dart';
import 'package:eva_connector/src/utils/py_test_script_runner.dart';

void main(List<String> args) async {
  final c = Config()..evaSoket = 'localhost:10001';

  final r = PyTestScriptRunner(
    '/home/andrei/documents/my/eva_ide/script_debug_runner/bin/eva4-svc-controller-py',
    '/home/andrei/documents/my/eva_py_macros_test',
    () => RpcClient.short(c),
  );

  final res = await r.run(
    'scriot-dir',
    Lmacro('lmacro:qwe/test1'),
    cvars: {
      'xxx': 1,
      'yyy': true,
      'zzz': {'first1': 132, 'second2': 345},
    },
  );
  print(res);
}
