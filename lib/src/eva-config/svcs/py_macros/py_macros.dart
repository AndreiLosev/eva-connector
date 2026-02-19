import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/has_files.dart';
import 'package:eva_connector/src/eva-config/svcs/py_macros/py_macros_config.dart';

class PyMacros extends BaseSvc<PyMacrosConfig> implements HasFiles {
  static const svcCommand = "venv/bin/eva4-svc-controller-py";

  Map<String, String> scripts = {};

  PyMacros(String id) : super(id, PyMacros.svcCommand, PyMacrosConfig());

  @override
  Map<String, String> getFiles() {
    return {
      for (var item in scripts.entries)
        '${config.macroDir}/${item.key}': item.value,
    };
  }

  @override
  void putFile(String name, String content) {
    scripts[name] = content;
  }

  @override
  String basePath() => config.macroDir;
}
