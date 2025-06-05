import 'package:dartssh2/dartssh2.dart';

class Client extends SSHClient {
  Client(
    super.socket, {
    required super.username,
    super.printDebug,
    super.printTrace,
    super.algorithms = const SSHAlgorithms(),
    super.onVerifyHostKey,
    super.identities,
    super.onPasswordRequest,
    super.onChangePasswordRequest,
    super.onUserInfoRequest,
    super.onUserauthBanner,
    super.onAuthenticated,
    super.keepAliveInterval = const Duration(seconds: 10),
  });
}
