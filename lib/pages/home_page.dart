import 'package:armadillo/models/ssh_client_record.dart';
import 'package:armadillo/pages/add_host_page.dart';
import 'package:armadillo/providers/all.dart';
import 'package:armadillo/widgets/ssh_client_record_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsBoxListenable = useValueListenable(clientsBoxProvider);
    final clients =
        clientsBoxListenable.get('clients')?.cast<SSHClientRecord>() ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (_) => const AddHostDialog());
        },
        child: const Icon(Icons.terminal_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final client = clients[index];
            return ProviderScope(
              overrides: [sshClientRecordProvider.overrideWithValue(client)],
              child: const SSHClientRecordCard(),
            );
          },
        ),
      ),
    );
  }
}
