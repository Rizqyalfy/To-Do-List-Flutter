import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../models/task_list_model.dart';
import '../datasources/task_api_service.dart';
import '../datasources/task_firebase_service.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_list_entity.dart';
import '../../../../core/constants/app_constants.dart';

class TaskRepository {
  final TaskApiService? _apiService;
  final TaskFirebaseService? _firebaseService;
  late Box<TaskModel> _taskBox;
  late Box<TaskListModel> _taskListBox;
  String _storageMode = AppConstants.storageMode;

  TaskRepository({
    TaskApiService? apiService,
    TaskFirebaseService? firebaseService,
  }) : _apiService = apiService,
       _firebaseService = firebaseService;

  Future<void> initialize() async {
    // Only initialize Hive if using hive mode
    if (_storageMode == 'hive') {
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TaskModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TaskListModelAdapter());
      }

      _taskBox = await Hive.openBox<TaskModel>(AppConstants.taskBoxName);
      _taskListBox = await Hive.openBox<TaskListModel>(
        AppConstants.taskListBoxName,
      );

      // If using local storage and no lists exist, create default
      if (_taskListBox.isEmpty) {
        await createTaskList(
          TaskListEntity(
            id: AppConstants.defaultListId,
            name: AppConstants.defaultListName,
            color: null,
            order: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }
    }
  }

  // Task operations
  Future<void> createTask(TaskEntity task) async {
    switch (_storageMode) {
      case 'firebase':
        if (_firebaseService != null) {
          await _firebaseService.createTask(task);
        }
        break;
      case 'api':
        if (_apiService != null) {
          try {
            await _apiService.createTask(task);
          } catch (e) {
            throw Exception('Failed to create task: $e');
          }
        }
        break;
      case 'hive':
      default:
        await _taskBox.put(task.id, TaskModel.fromEntity(task));
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    switch (_storageMode) {
      case 'firebase':
        if (_firebaseService != null) {
          await _firebaseService.updateTask(task);
        }
        break;
      case 'api':
        if (_apiService != null) {
          try {
            await _apiService.updateTask(task);
          } catch (e) {
            throw Exception('Failed to update task: $e');
          }
        }
        break;
      case 'hive':
      default:
        await _taskBox.put(task.id, TaskModel.fromEntity(task));
    }
  }

  Future<void> deleteTask(String taskId) async {
    switch (_storageMode) {
      case 'firebase':
        if (_firebaseService != null) {
          await _firebaseService.deleteTask(taskId);
        }
        break;
      case 'api':
        if (_apiService != null) {
          try {
            await _apiService.deleteTask(taskId);
          } catch (e) {
            throw Exception('Failed to delete task: $e');
          }
        }
        break;
      case 'hive':
      default:
        await _taskBox.delete(taskId);
    }
  }

  TaskEntity? getTask(String taskId) {
    if (_storageMode == 'hive') {
      final task = _taskBox.get(taskId);
      return task?.toEntity();
    }
    return null;
  }

  List<TaskEntity> getAllTasks() {
    if (_storageMode == 'hive') {
      return _taskBox.values.map((task) => task.toEntity()).toList();
    }
    return [];
  }

  Future<List<TaskEntity>> getTasksByList(String listId) async {
    switch (_storageMode) {
      case 'firebase':
        if (_firebaseService != null) {
          return await _firebaseService.getTasksByList(listId);
        }
        return [];
      case 'api':
        if (_apiService != null) {
          try {
            return await _apiService.getTasksByList(listId);
          } catch (e) {
            throw Exception('Failed to load tasks: $e');
          }
        }
        return [];
      case 'hive':
      default:
        return _taskBox.values
            .where((task) => task.listId == listId)
            .map((task) => task.toEntity())
            .toList();
    }
  }

  Stream<List<TaskEntity>> watchTasksByList(String listId) {
    if (_storageMode == 'firebase' && _firebaseService != null) {
      return _firebaseService.watchTasksByList(listId);
    }
    // For Hive and API modes, use polling approach
    return _taskBox
        .watch()
        .map((_) async {
          return await getTasksByList(listId);
        })
        .asyncMap((event) => event);
  }

  // Task List operations
  Future<void> createTaskList(TaskListEntity taskList) async {
    switch (_storageMode) {
      case 'firebase':
        if (_firebaseService != null) {
          await _firebaseService.createTaskList(taskList);
        }
        break;
      case 'api':
        if (_apiService != null) {
          try {
            await _apiService.createTaskList(taskList);
          } catch (e) {
            throw Exception('Failed to create task list: $e');
          }
        }
        break;
      case 'hive':
      default:
        await _taskListBox.put(taskList.id, TaskListModel.fromEntity(taskList));
    }
  }

  Future<void> updateTaskList(TaskListEntity taskList) async {
    switch (_storageMode) {
      case 'firebase':
        if (_firebaseService != null) {
          await _firebaseService.updateTaskList(taskList);
        }
        break;
      case 'api':
        if (_apiService != null) {
          try {
            await _apiService.updateTaskList(taskList);
          } catch (e) {
            throw Exception('Failed to update task list: $e');
          }
        }
        break;
      case 'hive':
      default:
        await _taskListBox.put(taskList.id, TaskListModel.fromEntity(taskList));
    }
  }

  Future<void> deleteTaskList(String listId) async {
    switch (_storageMode) {
      case 'firebase':
        if (_firebaseService != null) {
          await _firebaseService.deleteTaskList(listId);
        }
        break;
      case 'api':
        if (_apiService != null) {
          try {
            await _apiService.deleteTaskList(listId);
          } catch (e) {
            throw Exception('Failed to delete task list: $e');
          }
        }
        break;
      case 'hive':
      default:
        // Delete all tasks in this list first
        final tasksToDelete = await getTasksByList(listId);
        for (final task in tasksToDelete) {
          await deleteTask(task.id);
        }
        await _taskListBox.delete(listId);
    }
  }

  TaskListEntity? getTaskList(String listId) {
    final taskList = _taskListBox.get(listId);
    return taskList?.toEntity();
  }

  Future<List<TaskListEntity>> getAllTaskLists() async {
    switch (_storageMode) {
      case 'firebase':
        if (_firebaseService != null) {
          return await _firebaseService.getAllTaskLists();
        }
        return [];
      case 'api':
        if (_apiService != null) {
          try {
            return await _apiService.getAllTaskLists();
          } catch (e) {
            throw Exception('Failed to load task lists: $e');
          }
        }
        return [];
      case 'hive':
      default:
        final lists = _taskListBox.values
            .map((list) => list.toEntity())
            .toList();
        lists.sort((a, b) => a.order.compareTo(b.order));
        return lists;
    }
  }

  Stream<List<TaskListEntity>> watchTaskLists() {
    if (_storageMode == 'firebase' && _firebaseService != null) {
      return _firebaseService.watchTaskLists();
    }
    // For Hive and API modes
    return _taskListBox
        .watch()
        .map((_) async {
          return await getAllTaskLists();
        })
        .asyncMap((event) => event);
  }

  // Statistics
  Future<int> getCompletedTasksCount(String listId) async {
    if (_storageMode == 'firebase' && _firebaseService != null) {
      return await _firebaseService.getCompletedTasksCount(listId);
    }
    return _taskBox.values
        .where((task) => task.listId == listId && task.isCompleted)
        .length;
  }

  Future<int> getTotalTasksCount(String listId) async {
    if (_storageMode == 'firebase' && _firebaseService != null) {
      return await _firebaseService.getTotalTasksCount(listId);
    }
    return _taskBox.values.where((task) => task.listId == listId).length;
  }
}
