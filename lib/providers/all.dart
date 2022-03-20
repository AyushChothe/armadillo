import 'package:armadillo/models/ssh_client_record.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final clientsBox = Hive.box<List>('clientsBox');
final clientsBoxProvider = clientsBox.listenable();

final sshClientRecordProvider = Provider<SSHClientRecord?>((_) => null);
final sshClientProvider = Provider<SSHClient?>((_) => null);
