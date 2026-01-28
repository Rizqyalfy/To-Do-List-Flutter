import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../../data/repositories/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc({required this.repository}) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    try {
      emit(TaskLoading());
      final tasks = await repository.getTasksByList(event.listId);
      emit(TaskLoaded(tasks, event.listId));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await repository.createTask(event.task);
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        add(LoadTasks(currentState.currentListId));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await repository.updateTask(event.task);
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        add(LoadTasks(currentState.currentListId));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await repository.deleteTask(event.taskId);
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        add(LoadTasks(currentState.currentListId));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final updatedTask = event.task.copyWith(
        isCompleted: !event.task.isCompleted,
        updatedAt: DateTime.now(),
      );
      await repository.updateTask(updatedTask);
      if (state is TaskLoaded) {
        final currentState = state as TaskLoaded;
        add(LoadTasks(currentState.currentListId));
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
