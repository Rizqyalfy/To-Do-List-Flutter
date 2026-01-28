import 'package:equatable/equatable.dart';
import '../../domain/entities/task_list_entity.dart';

abstract class TaskListEvent extends Equatable {
  const TaskListEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskLists extends TaskListEvent {}

class AddTaskList extends TaskListEvent {
  final TaskListEntity taskList;

  const AddTaskList(this.taskList);

  @override
  List<Object?> get props => [taskList];
}

class UpdateTaskList extends TaskListEvent {
  final TaskListEntity taskList;

  const UpdateTaskList(this.taskList);

  @override
  List<Object?> get props => [taskList];
}

class DeleteTaskList extends TaskListEvent {
  final String listId;

  const DeleteTaskList(this.listId);

  @override
  List<Object?> get props => [listId];
}

class SelectTaskList extends TaskListEvent {
  final String listId;

  const SelectTaskList(this.listId);

  @override
  List<Object?> get props => [listId];
}
