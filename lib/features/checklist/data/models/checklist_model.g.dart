// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChecklistItemModelAdapter extends TypeAdapter<ChecklistItemModel> {
  @override
  final int typeId = 20;

  @override
  ChecklistItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistItemModel(
      modelId: fields[0] as String,
      modelName: fields[1] as String,
      modelCategory: fields[2] as String,
      modelIsChecked: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistItemModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.modelId)
      ..writeByte(1)
      ..write(obj.modelName)
      ..writeByte(2)
      ..write(obj.modelCategory)
      ..writeByte(3)
      ..write(obj.modelIsChecked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChecklistConfigModelAdapter extends TypeAdapter<ChecklistConfigModel> {
  @override
  final int typeId = 21;

  @override
  ChecklistConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistConfigModel(
      modelExperience: fields[0] as HikerExperience,
      modelDuration: fields[1] as TrekDuration,
      modelWeather: fields[2] as WeatherCondition,
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistConfigModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.modelExperience)
      ..writeByte(1)
      ..write(obj.modelDuration)
      ..writeByte(2)
      ..write(obj.modelWeather);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserChecklistModelAdapter extends TypeAdapter<UserChecklistModel> {
  @override
  final int typeId = 22;

  @override
  UserChecklistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserChecklistModel(
      modelItems: (fields[0] as List).cast<ChecklistItemModel>(),
      modelConfig: fields[1] as ChecklistConfigModel,
      modelUpdatedAt: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserChecklistModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.modelItems)
      ..writeByte(1)
      ..write(obj.modelConfig)
      ..writeByte(2)
      ..write(obj.modelUpdatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserChecklistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
