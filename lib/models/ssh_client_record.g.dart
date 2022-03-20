// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ssh_client_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SSHClientRecordAdapter extends TypeAdapter<SSHClientRecord> {
  @override
  final int typeId = 1;

  @override
  SSHClientRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SSHClientRecord(
      name: fields[0] as String,
      host: fields[1] as String,
      port: fields[2] as int,
      username: fields[3] as String,
      password: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SSHClientRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.host)
      ..writeByte(2)
      ..write(obj.port)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SSHClientRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
