import 'package:armadillo/models/ssh_client_record.dart';
import 'package:armadillo/providers/all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddHostDialog extends HookConsumerWidget {
  const AddHostDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameCtrl = useTextEditingController(text: "Server");
    final hostCtrl = useTextEditingController(text: "localhost");
    final portCtrl = useTextEditingController(text: "22");
    final userCtrl = useTextEditingController(text: "root");
    final passCtrl = useTextEditingController(text: "root");
    final _formKey = GlobalKey<FormState>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text("Add new host"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  label: Text("Name"),
                  hintText: "Server Name",
                ),
                validator: (val) =>
                    (val != null && val.trim() != "") ? null : "Invalid Name",
              ),
              TextFormField(
                controller: hostCtrl,
                decoration: const InputDecoration(
                  label: Text("Host"),
                  hintText: "localhost",
                ),
                validator: (val) =>
                    (val != null && val.trim() != "") ? null : "Invalid Host",
              ),
              TextFormField(
                controller: portCtrl,
                decoration: const InputDecoration(
                  label: Text("Port"),
                  hintText: "22",
                ),
                validator: (val) => (val != null &&
                        val.trim() != "" &&
                        int.tryParse(val.trim()) != null)
                    ? null
                    : "Invalid Port",
              ),
              TextFormField(
                controller: userCtrl,
                decoration: const InputDecoration(
                  label: Text("Username"),
                  hintText: "root",
                ),
                validator: (val) => (val != null && val.trim() != "")
                    ? null
                    : "Invalid Username",
              ),
              TextFormField(
                controller: passCtrl,
                decoration: const InputDecoration(
                  label: Text("Password"),
                ),
                validator: (val) => (val != null && val.trim() != "")
                    ? null
                    : "Invalid Password",
              ),
            ]
                .expand(
                  (e) => [
                    e,
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                )
                .toList()
              ..removeLast(),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton.icon(
          icon: const Icon(
            Icons.add,
          ),
          onPressed: (() async {
            if (_formKey.currentState?.validate() ?? false) {
              try {
                final client = SSHClientRecord(
                  name: nameCtrl.text.trim(),
                  host: hostCtrl.text.trim(),
                  port: int.tryParse(portCtrl.text.trim()) ?? 22,
                  username: userCtrl.text.trim(),
                  password: passCtrl.text.trim(),
                );

                final _clients = clientsBox.get('clients') ?? [];
                await clientsBox.put('clients', (_clients) + [client]);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Host Added Successfully!")));
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }
          }),
          label: const Text("Add"),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.close),
          onPressed: (() {
            Navigator.pop(context);
          }),
          label: const Text("Cancel"),
        ),
      ]
          .map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: e,
              ))
          .toList(),
    );
  }
}
