import 'package:equatable/equatable.dart';
import '../../domain/entities/task_list_entity.dart';

abstract class TaskListState extends Equatable {
  const TaskListState();

  @override
  List<Object?> get props => [];
}

class TaskListInitial extends TaskListState {}

class TaskListLoading extends TaskListState {}

class TaskListLoaded extends TaskListState {
  final List<TaskListEntity> taskLists;
  final String? selectedListId;

  const TaskListLoaded(this.taskLists, {this.selectedListId});

  @override
  List<Object?> get props => [taskLists, selectedListId];
}

class TaskListError extends TaskListState {
  final String message;

  const TaskListError(this.message);

  @override
  List<Object?> get props => [message];
}
