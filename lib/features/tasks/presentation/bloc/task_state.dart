import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final String currentListId;

  const TaskLoaded(this.tasks, this.currentListId);

  @override
  List<Object?> get props => [tasks, currentListId];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
