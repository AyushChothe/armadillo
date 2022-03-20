import 'package:armadillo/pages/terminal_tab_view_page.dart';
import 'package:armadillo/providers/all.dart';
import 'package:armadillo/utils/ssh_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SSHClientRecordCard extends HookConsumerWidget {
  const SSHClientRecordCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(sshClientRecordProvider)!;
    return Card(
      child: ListTile(
        title: Text(client.name),
        subtitle: Text(
            "${client.username}@${client.host}:${client.port} (${client.password})"),
        leading: const CircleAvatar(child: Icon(Icons.terminal_rounded)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_forever_rounded),
          onPressed: () {},
        ),
        onTap: () async {
          try {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Dialog(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("Connecting..."),
                    leading: CircularProgressIndicator(),
                  ),
                ),
              ),
            );
            final sshClient = await SSHUtils.getSSHClient(
              host: client.host,
              port: client.port,
              user: client.username,
              pass: client.password,
            );

            Navigator.pop(context);
            if (sshClient != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Connected to ${client.name} Server")));
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProviderScope(
                    overrides: [sshClientProvider.overrideWithValue(sshClient)],
                    child: const TerminalTabViewPage(),
                  ),
                ),
              );
              sshClient.close();
              debugPrint("${client.name} Closed");
            }
          } catch (e) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
      ),
    );
  }
}
