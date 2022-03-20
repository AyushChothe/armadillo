import 'package:armadillo/backends/ssh_backend.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:xterm/xterm.dart';

class SSHUtils {
  static Future<SSHClient?> getSSHClient(
      {required String host,
      required int port,
      required String user,
      String? pass}) async {
    final socket = await SSHSocket.connect(
      host,
      port,
      timeout: const Duration(seconds: 30),
    );
    final client = SSHClient(
      socket,
      username: user,
      onPasswordRequest: () => pass,
    );
    await client.authenticated;
    return client;
  }

  static Future<Terminal> getTerminal(
      {required SSHClient sshClient, VoidCallback? onClosed}) async {
    final backend =
        SSHTerminalBackend(sshClient: sshClient, onClosed: onClosed ?? () {});
    final terminal = Terminal(backend: backend, maxLines: 10000);

    return terminal;
  }
}
