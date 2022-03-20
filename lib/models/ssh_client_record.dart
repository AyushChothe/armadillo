import 'package:hive/hive.dart';

part 'ssh_client_record.g.dart';

@HiveType(typeId: 1)
class SSHClientRecord extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String host;

  @HiveField(2)
  final int port;

  @HiveField(3)
  final String username;

  @HiveField(4)
  final String password;

  SSHClientRecord({
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password,
  });
}
