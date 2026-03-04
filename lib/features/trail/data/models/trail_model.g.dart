// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrailModelAdapter extends TypeAdapter<TrailModel> {
  @override
  final int typeId = 1;

  @override
  TrailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrailModel(
      id: fields[0] as String,
      name: fields[1] as String,
      location: fields[2] as String,
      region: fields[3] as String?,
      distance: fields[4] as double,
      elevation: fields[5] as double,
      duration: fields[6] as DurationModel?,
      durationDays: fields[7] as int?,
      difficulty: fields[8] as String,
      description: fields[9] as String?,
      highlights: (fields[10] as List).cast<String>(),
      images: (fields[11] as List).cast<String>(),
      features: (fields[12] as List).cast<String>(),
      seasons: (fields[13] as List).cast<String>(),
      ratings: (fields[14] as List).cast<RatingModel>(),
      averageRating: fields[15] as double,
      numRatings: fields[16] as int,
      createdAt: fields[17] as DateTime,
      updatedAt: fields[18] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TrailModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.region)
      ..writeByte(4)
      ..write(obj.distance)
      ..writeByte(5)
      ..write(obj.elevation)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.durationDays)
      ..writeByte(8)
      ..write(obj.difficulty)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.highlights)
      ..writeByte(11)
      ..write(obj.images)
      ..writeByte(12)
      ..write(obj.features)
      ..writeByte(13)
      ..write(obj.seasons)
      ..writeByte(14)
      ..write(obj.ratings)
      ..writeByte(15)
      ..write(obj.averageRating)
      ..writeByte(16)
      ..write(obj.numRatings)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DurationModelAdapter extends TypeAdapter<DurationModel> {
  @override
  final int typeId = 10;

  @override
  DurationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DurationModel(
      min: fields[0] as int,
      max: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DurationModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.min)
      ..writeByte(1)
      ..write(obj.max);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DurationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RatingModelAdapter extends TypeAdapter<RatingModel> {
  @override
  final int typeId = 11;

  @override
  RatingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RatingModel(
      userId: fields[0] as String?,
      rating: fields[1] as int,
      review: fields[2] as String?,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RatingModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.rating)
      ..writeByte(2)
      ..write(obj.review)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
