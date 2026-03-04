// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupParticipantModelAdapter extends TypeAdapter<GroupParticipantModel> {
  @override
  final int typeId = 12;

  @override
  GroupParticipantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupParticipantModel(
      odlUserId: fields[0] as String,
      odlUsername: fields[1] as String,
      odlProfilePicture: fields[2] as String?,
      odlRoleString: fields[3] as String,
      odlJoinedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GroupParticipantModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.odlUserId)
      ..writeByte(1)
      ..write(obj.odlUsername)
      ..writeByte(2)
      ..write(obj.odlProfilePicture)
      ..writeByte(3)
      ..write(obj.odlRoleString)
      ..writeByte(4)
      ..write(obj.odlJoinedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupParticipantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeetingPointModelAdapter extends TypeAdapter<MeetingPointModel> {
  @override
  final int typeId = 13;

  @override
  MeetingPointModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeetingPointModel(
      odlName: fields[0] as String,
      odlLatitude: fields[1] as double,
      odlLongitude: fields[2] as double,
      odlDescription: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MeetingPointModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.odlName)
      ..writeByte(1)
      ..write(obj.odlLatitude)
      ..writeByte(2)
      ..write(obj.odlLongitude)
      ..writeByte(3)
      ..write(obj.odlDescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingPointModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GroupCommentModelAdapter extends TypeAdapter<GroupCommentModel> {
  @override
  final int typeId = 14;

  @override
  GroupCommentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupCommentModel(
      odlId: fields[0] as String,
      odlUserId: fields[1] as String,
      odlUsername: fields[2] as String,
      odlUserProfilePicture: fields[3] as String?,
      odlContent: fields[4] as String,
      odlCreatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GroupCommentModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.odlId)
      ..writeByte(1)
      ..write(obj.odlUserId)
      ..writeByte(2)
      ..write(obj.odlUsername)
      ..writeByte(3)
      ..write(obj.odlUserProfilePicture)
      ..writeByte(4)
      ..write(obj.odlContent)
      ..writeByte(5)
      ..write(obj.odlCreatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupCommentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GroupModelAdapter extends TypeAdapter<GroupModel> {
  @override
  final int typeId = 2;

  @override
  GroupModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupModel(
      odlId: fields[0] as String,
      odlName: fields[1] as String,
      odlDescription: fields[2] as String?,
      odlTrailId: fields[3] as String,
      odlTrailName: fields[4] as String,
      odlTrailImage: fields[5] as String?,
      odlStartDate: fields[6] as DateTime,
      odlEndDate: fields[7] as DateTime?,
      odlMaxParticipants: fields[8] as int,
      odlStatusString: fields[9] as String,
      odlParticipantModels: (fields[10] as List).cast<GroupParticipantModel>(),
      odlMeetingPointModel: fields[11] as MeetingPointModel?,
      odlCommentModels: (fields[12] as List).cast<GroupCommentModel>(),
      odlCreatorId: fields[13] as String,
      odlCreatedAt: fields[14] as DateTime,
      odlUpdatedAt: fields[15] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GroupModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.odlId)
      ..writeByte(1)
      ..write(obj.odlName)
      ..writeByte(2)
      ..write(obj.odlDescription)
      ..writeByte(3)
      ..write(obj.odlTrailId)
      ..writeByte(4)
      ..write(obj.odlTrailName)
      ..writeByte(5)
      ..write(obj.odlTrailImage)
      ..writeByte(6)
      ..write(obj.odlStartDate)
      ..writeByte(7)
      ..write(obj.odlEndDate)
      ..writeByte(8)
      ..write(obj.odlMaxParticipants)
      ..writeByte(9)
      ..write(obj.odlStatusString)
      ..writeByte(10)
      ..write(obj.odlParticipantModels)
      ..writeByte(11)
      ..write(obj.odlMeetingPointModel)
      ..writeByte(12)
      ..write(obj.odlCommentModels)
      ..writeByte(13)
      ..write(obj.odlCreatorId)
      ..writeByte(14)
      ..write(obj.odlCreatedAt)
      ..writeByte(15)
      ..write(obj.odlUpdatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
