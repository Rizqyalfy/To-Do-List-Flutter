import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_list_event.dart';
import 'task_list_state.dart';
import '../../data/repositories/task_repository.dart';
import '../../../../core/constants/app_constants.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskRepository repository;

  TaskListBloc({required this.repository}) : super(TaskListInitial()) {
    on<LoadTaskLists>(_onLoadTaskLists);
    on<AddTaskList>(_onAddTaskList);
    on<UpdateTaskList>(_onUpdateTaskList);
    on<DeleteTaskList>(_onDeleteTaskList);
    on<SelectTaskList>(_onSelectTaskList);
  }

  Future<void> _onLoadTaskLists(
    LoadTaskLists event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      emit(TaskListLoading());
      final taskLists = await repository.getAllTaskLists();
      emit(
        TaskListLoaded(taskLists, selectedListId: AppConstants.defaultListId),
      );
    } catch (e) {
      emit(TaskListError(e.toString()));
    }
  }

  Future<void> _onAddTaskList(
    AddTaskList event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      await repository.createTaskList(event.taskList);
      add(LoadTaskLists());
    } catch (e) {
      emit(TaskListError(e.toString()));
    }
  }

  Future<void> _onUpdateTaskList(
    UpdateTaskList event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      await repository.updateTaskList(event.taskList);
      add(LoadTaskLists());
    } catch (e) {
      emit(TaskListError(e.toString()));
    }
  }

  Future<void> _onDeleteTaskList(
    DeleteTaskList event,
    Emitter<TaskListState> emit,
  ) async {
    try {
      await repository.deleteTaskList(event.listId);
      add(LoadTaskLists());
    } catch (e) {
      emit(TaskListError(e.toString()));
    }
  }

  Future<void> _onSelectTaskList(
    SelectTaskList event,
    Emitter<TaskListState> emit,
  ) async {
    if (state is TaskListLoaded) {
      final currentState = state as TaskListLoaded;
      emit(
        TaskListLoaded(currentState.taskLists, selectedListId: event.listId),
      );
    }
  }
}
