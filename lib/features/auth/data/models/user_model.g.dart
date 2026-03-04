// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      phone: fields[3] as String?,
      hikerType: fields[4] as String,
      ageGroup: fields[5] as String?,
      emergencyContact: fields[6] as EmergencyContactModel?,
      bio: fields[7] as String,
      profileImage: fields[8] as String,
      joinDate: fields[9] as DateTime,
      role: fields[10] as String,
      subscription: fields[11] as String,
      subscriptionExpiresAt: fields[12] as DateTime?,
      stats: fields[13] as UserStatsModel,
      achievements: (fields[14] as List).cast<String>(),
      completedTrails: (fields[15] as List).cast<CompletedTrailModel>(),
      joinedTrails: (fields[16] as List).cast<JoinedTrailModel>(),
      createdAt: fields[17] as DateTime?,
      updatedAt: fields[18] as DateTime?,
      token: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.hikerType)
      ..writeByte(5)
      ..write(obj.ageGroup)
      ..writeByte(6)
      ..write(obj.emergencyContact)
      ..writeByte(7)
      ..write(obj.bio)
      ..writeByte(8)
      ..write(obj.profileImage)
      ..writeByte(9)
      ..write(obj.joinDate)
      ..writeByte(10)
      ..write(obj.role)
      ..writeByte(11)
      ..write(obj.subscription)
      ..writeByte(12)
      ..write(obj.subscriptionExpiresAt)
      ..writeByte(13)
      ..write(obj.stats)
      ..writeByte(14)
      ..write(obj.achievements)
      ..writeByte(15)
      ..write(obj.completedTrails)
      ..writeByte(16)
      ..write(obj.joinedTrails)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.updatedAt)
      ..writeByte(19)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmergencyContactModelAdapter extends TypeAdapter<EmergencyContactModel> {
  @override
  final int typeId = 7;

  @override
  EmergencyContactModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmergencyContactModel(
      name: fields[0] as String?,
      phone: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EmergencyContactModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyContactModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserStatsModelAdapter extends TypeAdapter<UserStatsModel> {
  @override
  final int typeId = 6;

  @override
  UserStatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStatsModel(
      totalHikes: fields[0] as int,
      totalDistance: fields[1] as double,
      totalElevation: fields[2] as double,
      totalHours: fields[3] as double,
      hikesJoined: fields[4] as int,
      hikesLed: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserStatsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.totalHikes)
      ..writeByte(1)
      ..write(obj.totalDistance)
      ..writeByte(2)
      ..write(obj.totalElevation)
      ..writeByte(3)
      ..write(obj.totalHours)
      ..writeByte(4)
      ..write(obj.hikesJoined)
      ..writeByte(5)
      ..write(obj.hikesLed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompletedTrailModelAdapter extends TypeAdapter<CompletedTrailModel> {
  @override
  final int typeId = 8;

  @override
  CompletedTrailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompletedTrailModel(
      trailId: fields[0] as String,
      completedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CompletedTrailModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.trailId)
      ..writeByte(1)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletedTrailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JoinedTrailModelAdapter extends TypeAdapter<JoinedTrailModel> {
  @override
  final int typeId = 9;

  @override
  JoinedTrailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JoinedTrailModel(
      id: fields[0] as String?,
      trailId: fields[1] as String,
      scheduledDate: fields[2] as DateTime,
      addedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, JoinedTrailModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.trailId)
      ..writeByte(2)
      ..write(obj.scheduledDate)
      ..writeByte(3)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JoinedTrailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
