import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:eva_connector/src/config.dart';

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

  static Future<Client> makeTunnel(Config config) async {
    final command =
        "socat TCP-LISTEN:${config.evaIp},reuseaddr,fork UNIX-CLIENT:/tmp/foo";
    final socket = await SSHSocket.connect(config.evaIp, config.evaSshPort);

    final client = Client(
      socket,
      username: config.sshUser,
      onPasswordRequest: () => config.sshPassword,
    );

    await client.authenticated;

    final serverSocket = await ServerSocket.bind('127.0.0.1', 123);

    serverSocket.listen((socket) async {
      final forward = await client.forwardLocal(config.evaIp, 123);
      forward.stream.cast<List<int>>().pipe(socket);
      socket.cast<List<int>>().pipe(forward.sink);
    });

    return client;
  }
}
