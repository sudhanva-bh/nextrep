// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseSessionAdapter extends TypeAdapter<ExerciseSession> {
  @override
  final int typeId = 3;

  @override
  ExerciseSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseSession(
      workoutId: fields[0] as String,
      sets: (fields[1] as List).cast<ExerciseSet>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseSession obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.workoutId)
      ..writeByte(1)
      ..write(obj.sets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
