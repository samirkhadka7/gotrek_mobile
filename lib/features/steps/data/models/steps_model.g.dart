// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steps_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StepRecordModelAdapter extends TypeAdapter<StepRecordModel> {
  @override
  final int typeId = 23;

  @override
  StepRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepRecordModel(
      modelId: fields[0] as String,
      modelSteps: fields[1] as int,
      modelDistance: fields[2] as double,
      modelCalories: fields[3] as int,
      modelDate: fields[4] as DateTime,
      modelActiveMinutes: fields[5] as int,
      modelGoal: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StepRecordModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.modelId)
      ..writeByte(1)
      ..write(obj.modelSteps)
      ..writeByte(2)
      ..write(obj.modelDistance)
      ..writeByte(3)
      ..write(obj.modelCalories)
      ..writeByte(4)
      ..write(obj.modelDate)
      ..writeByte(5)
      ..write(obj.modelActiveMinutes)
      ..writeByte(6)
      ..write(obj.modelGoal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StepGoalModelAdapter extends TypeAdapter<StepGoalModel> {
  @override
  final int typeId = 24;

  @override
  StepGoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepGoalModel(
      modelDailyGoal: fields[0] as int,
      modelWeeklyGoal: fields[1] as int,
      modelNotificationsEnabled: fields[2] as bool,
      modelReminderHour: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StepGoalModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.modelDailyGoal)
      ..writeByte(1)
      ..write(obj.modelWeeklyGoal)
      ..writeByte(2)
      ..write(obj.modelNotificationsEnabled)
      ..writeByte(3)
      ..write(obj.modelReminderHour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepGoalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StepSessionModelAdapter extends TypeAdapter<StepSessionModel> {
  @override
  final int typeId = 25;

  @override
  StepSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepSessionModel(
      modelId: fields[0] as String,
      modelStartTime: fields[1] as DateTime,
      modelEndTime: fields[2] as DateTime?,
      modelSteps: fields[3] as int,
      modelDistance: fields[4] as double,
      modelCalories: fields[5] as int,
      modelTrailId: fields[6] as String?,
      modelTrailName: fields[7] as String?,
      modelStatus: fields[8] as SessionStatus,
    );
  }

  @override
  void write(BinaryWriter writer, StepSessionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.modelId)
      ..writeByte(1)
      ..write(obj.modelStartTime)
      ..writeByte(2)
      ..write(obj.modelEndTime)
      ..writeByte(3)
      ..write(obj.modelSteps)
      ..writeByte(4)
      ..write(obj.modelDistance)
      ..writeByte(5)
      ..write(obj.modelCalories)
      ..writeByte(6)
      ..write(obj.modelTrailId)
      ..writeByte(7)
      ..write(obj.modelTrailName)
      ..writeByte(8)
      ..write(obj.modelStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
