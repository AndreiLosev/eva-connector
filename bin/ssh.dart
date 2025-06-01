import 'dart:io';

import 'package:dartssh2/dartssh2.dart';

void main(List<String> args) async {
  await sshExample();
}

Future<void> sshExample() async {
  final socket = await SSHSocket.connect('192.168.1.16', 22);

  final client = SSHClient(
    socket,
    username: 'root',
    onPasswordRequest: () => '123',
  );

  await client.authenticated;

  final serverSocket = await ServerSocket.bind('localhost', 10001);

  print('Listening on ${serverSocket.address.address}:${serverSocket.port}');

  await for (final socket in serverSocket) {
    final forward = await client.forwardLocal('192.168.1.16', 10001);
    forward.stream.cast<List<int>>().pipe(socket);
    socket.cast<List<int>>().pipe(forward.sink);
  }

  client.close();
  await client.done;
}
