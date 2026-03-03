import 'package:eva_connector/eva_connector.dart';

class PyMacros extends BaseSvc<PyMacrosConfig> implements HasFiles {
  static const svcCommand = "venv/bin/eva4-svc-controller-py";

  Map<String, String> scripts = {};

  PyMacros(String id) : super(id, PyMacros.svcCommand, PyMacrosConfig());

  @override
  Map<String, String> getFiles() {
    return {
      for (var item in scripts.entries)
        '${config.macroDir}/${item.key.replaceFirst('${Lmacro.name}:', '')}.py':
            item.value,
    };
  }

  @override
  void putFile(String name, String content) {
    final key = "${Lmacro.name}:${name.replaceFirst(RegExp(r'\.py$'), '')}";
    scripts[key] = content;
  }

  @override
  String basePath() => config.macroDir;
}
