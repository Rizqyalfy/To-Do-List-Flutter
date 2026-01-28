import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? dueDate;
  final int priority; // 0: None, 1: Low, 2: Medium, 3: High
  final String listId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    this.dueDate,
    required this.priority,
    required this.listId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        dueDate,
        priority,
        listId,
        createdAt,
        updatedAt,
      ];

  TaskEntity copyWith({
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
    return TaskEntity(
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
