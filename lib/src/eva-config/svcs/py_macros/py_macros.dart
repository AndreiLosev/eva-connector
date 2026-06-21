import 'dart:convert';

import 'package:eva_connector/eva_connector.dart';

class PyMacros extends BaseSvc<PyMacrosConfig> implements HasFiles {
  static const svcCommand = "venv/bin/softkip-svc-controller-py";

  Map<String, String> scripts = {};

  PyMacros(String id) : super(id, PyMacros.svcCommand, PyMacrosConfig());

  @override
  List<UploadItem> getFiles() {
    return [
      for (var item in scripts.entries)
        if (item.value.isNotEmpty)
          UploadItemText(
            '${config.macroDir}/${item.key.replaceFirst('${Lmacro.name}:', '')}.py',
            item.value,
          ),
    ];
  }

  @override
  void putFile(String name, List<int> content, [bool checkItYourself = false]) {
    final key =
        "${Lmacro.name}:${name.replaceFirst(RegExp('^${config.macroDir}/'), '').replaceFirst(RegExp(r'\.py$'), '')}";
    scripts[key] = utf8.decode(content);
  }

  @override
  String basePath() => config.macroDir;
}
