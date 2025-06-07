import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/script_runner_controller/script_runner_config.dart';

class ScriptRunnerController extends BaseSvc<ScriptRunnerConfig> {
  static const svcCommand = "svc/eva-controller-sr";
  ScriptRunnerController(String id)
    : super(id, ScriptRunnerController.svcCommand, ScriptRunnerConfig());
}
