import 'package:armadillo/providers/all.dart';
import 'package:armadillo/utils/ssh_utils.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xterm/frontend/terminal_view.dart';
import 'package:xterm/xterm.dart';

class TerminalPage extends HookConsumerWidget {
  const TerminalPage({Key? key, required this.onClosed}) : super(key: key);

  final VoidCallback onClosed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SSHClient sshClient = ref.watch(sshClientProvider)!;
    final terFut = useMemoized(
      () => SSHUtils.getTerminal(
        sshClient: sshClient,
        onClosed: onClosed,
      ),
    );
    final snap = useFuture(terFut, preserveState: true);

    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: ((context) {
            if (snap.hasError) {
              return Center(
                child: Text(snap.error.toString()),
              );
            }

            if (!snap.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            Terminal terminal = snap.data!;

            return TerminalView(
              terminal: terminal,
              enableSuggestions: true,
              autocorrect: true,
              autofocus: true,
              style: const TerminalStyle(
                fontFamily: TerminalStyle.defaultFontFamily,
                fontSize: 16,
              ),
            );
          }),
        ),
      ),
    );
  }
}
