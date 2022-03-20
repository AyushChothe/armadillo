import 'dart:async';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

class SSHTerminalBackend extends TerminalBackend {
  final Completer<int> _exitCodeCompleter = Completer();
  final StreamController<String> _outStream = StreamController();
  final SSHClient sshClient;
  final VoidCallback onClosed;
  SSHSession? shell;

  SSHTerminalBackend({required this.sshClient, required this.onClosed});

  @override
  void ackProcessed() {}

  @override
  Future<int> get exitCode => _exitCodeCompleter.future;

  @override
  void init() async {
    try {
      shell = await sshClient.shell();
      shell?.stdout.listen((o) => _outStream.sink.add(String.fromCharCodes(o)));
      shell?.stderr.listen((e) => _outStream.sink.add(String.fromCharCodes(e)));
      shell?.done.whenComplete(onClosed);
    } catch (e) {
      debugPrint(e.toString());
      onClosed();
    }
    debugPrint("Init");
  }

  @override
  Stream<String> get out => _outStream.stream;

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {
    shell?.resizeTerminal(width, height);
  }

  @override
  void terminate() async {
    shell?.kill(SSHSignal.KILL);
    await shell?.done;
    _exitCodeCompleter.complete(shell?.exitCode);
    debugPrint("Terminate");
  }

  @override
  void write(String input) async {
    shell?.stdin.add(Uint8List.fromList(input.codeUnits));
  }
}
