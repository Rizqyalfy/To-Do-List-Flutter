import 'package:hive/hive.dart';
import '../../domain/entities/task_list_entity.dart';

part 'task_list_model.g.dart';

@HiveType(typeId: 1)
class TaskListModel extends TaskListEntity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? color;

  @HiveField(3)
  final int order;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  const TaskListModel({
    required this.id,
    required this.name,
    this.color,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
         id: id,
         name: name,
         color: color,
         order: order,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory TaskListModel.fromEntity(TaskListEntity entity) {
    return TaskListModel(
      id: entity.id,
      name: entity.name,
      color: entity.color,
      order: entity.order,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  TaskListEntity toEntity() {
    return TaskListEntity(
      id: id,
      name: name,
      color: color,
      order: order,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  TaskListModel copyWith({
    String? id,
    String? name,
    String? color,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskListModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
