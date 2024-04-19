// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_capsule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeCapsuleAdapter extends TypeAdapter<TimeCapsule> {
  @override
  final int typeId = 0;

  @override
  TimeCapsule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeCapsule(
      title: fields[0] as String,
      message: fields[1] as String,
      description: fields[2] as String,
      unlockDate: fields[3] as DateTime,
      isArchived: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TimeCapsule obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.unlockDate)
      ..writeByte(4)
      ..write(obj.isArchived);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeCapsuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
