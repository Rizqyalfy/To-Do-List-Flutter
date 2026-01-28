import 'package:equatable/equatable.dart';

class TaskListEntity extends Equatable {
  final String id;
  final String name;
  final String? color;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskListEntity({
    required this.id,
    required this.name,
    this.color,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, color, order, createdAt, updatedAt];

  TaskListEntity copyWith({
    String? id,
    String? name,
    String? color,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskListEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
