// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskListModelAdapter extends TypeAdapter<TaskListModel> {
  @override
  final int typeId = 1;

  @override
  TaskListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskListModel(
      id: fields[0] as String,
      name: fields[1] as String,
      color: fields[2] as String?,
      order: fields[3] as int,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TaskListModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.order)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
