import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/py_macros/py_macros_config.dart';

class PyMacros extends BaseSvc<PyMacrosConfig> {
  static const svcCommand = "venv/bin/eva4-svc-controller-py";
  PyMacros(String id) : super(id, PyMacros.svcCommand, PyMacrosConfig());
}
