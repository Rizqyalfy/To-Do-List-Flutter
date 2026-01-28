import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  final String listId;

  const LoadTasks(this.listId);

  @override
  List<Object?> get props => [listId];
}

class AddTask extends TaskEvent {
  final TaskEntity task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final TaskEntity task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskCompletion extends TaskEvent {
  final TaskEntity task;

  const ToggleTaskCompletion(this.task);

  @override
  List<Object?> get props => [task];
}
