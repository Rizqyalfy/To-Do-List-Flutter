import 'package:hive/hive.dart';
import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends TaskEntity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime? dueDate;

  @HiveField(5)
  final int priority;

  @HiveField(6)
  final String listId;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    this.dueDate,
    required this.priority,
    required this.listId,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          isCompleted: isCompleted,
          dueDate: dueDate,
          priority: priority,
          listId: listId,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      dueDate: entity.dueDate,
      priority: entity.priority,
      listId: entity.listId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      dueDate: dueDate,
      priority: priority,
      listId: listId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    int? priority,
    String? listId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      listId: listId ?? this.listId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
