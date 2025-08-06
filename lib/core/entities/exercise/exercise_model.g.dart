// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 1;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      bodyPart: fields[4] as String,
      targetMuscle: fields[5] as String,
      secondaryMuscles: (fields[6] as List).cast<String>(),
      image0: fields[7] as String,
      image1: fields[8] as String,
      instructions: (fields[9] as List).cast<String>(),
      difficulty: fields[10] as String,
      equipment: fields[11] as String,
      nickname: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.bodyPart)
      ..writeByte(5)
      ..write(obj.targetMuscle)
      ..writeByte(6)
      ..write(obj.secondaryMuscles)
      ..writeByte(7)
      ..write(obj.image0)
      ..writeByte(8)
      ..write(obj.image1)
      ..writeByte(9)
      ..write(obj.instructions)
      ..writeByte(10)
      ..write(obj.difficulty)
      ..writeByte(11)
      ..write(obj.equipment)
      ..writeByte(12)
      ..write(obj.nickname);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
