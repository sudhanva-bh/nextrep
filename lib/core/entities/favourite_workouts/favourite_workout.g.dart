// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_workout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteWorkoutAdapter extends TypeAdapter<FavouriteWorkout> {
  @override
  final int typeId = 6;

  @override
  FavouriteWorkout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouriteWorkout(
      id: fields[0] as String,
      workout: fields[1] as Workout,
    );
  }

  @override
  void write(BinaryWriter writer, FavouriteWorkout obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.workout);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteWorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
