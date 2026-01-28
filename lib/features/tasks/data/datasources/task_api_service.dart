import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_list_entity.dart';

import '../../../../core/network/api_client.dart';

class TaskApiService {
  final ApiClient _apiClient;

  TaskApiService(this._apiClient);

  // Task List API calls
  Future<List<TaskListEntity>> getAllTaskLists() async {
    try {
      final response = await _apiClient.get('/task-lists');
      final data = response.data['data'] as List;
      return data.map((json) => _parseTaskListFromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load task lists: $e');
    }
  }

  Future<TaskListEntity> createTaskList(TaskListEntity taskList) async {
    try {
      final response = await _apiClient.post(
        '/task-lists',
        data: {
          'name': taskList.name,
          'color': taskList.color,
          'order': taskList.order,
        },
      );
      return _parseTaskListFromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to create task list: $e');
    }
  }

  Future<TaskListEntity> updateTaskList(TaskListEntity taskList) async {
    try {
      final response = await _apiClient.put(
        '/task-lists/${taskList.id}',
        data: {
          'name': taskList.name,
          'color': taskList.color,
          'order': taskList.order,
        },
      );
      return _parseTaskListFromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to update task list: $e');
    }
  }

  Future<void> deleteTaskList(String listId) async {
    try {
      await _apiClient.delete('/task-lists/$listId');
    } catch (e) {
      throw Exception('Failed to delete task list: $e');
    }
  }

  // Task API calls
  Future<List<TaskEntity>> getTasksByList(String listId) async {
    try {
      final response = await _apiClient.get(
        '/tasks',
        queryParameters: {'task_list_id': listId},
      );
      final data = response.data['data'] as List;
      return data.map((json) => _parseTaskFromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<TaskEntity> createTask(TaskEntity task) async {
    try {
      final response = await _apiClient.post(
        '/tasks',
        data: {
          'title': task.title,
          'description': task.description,
          'is_completed': task.isCompleted,
          'due_date': task.dueDate?.toIso8601String(),
          'priority': task.priority,
          'task_list_id': int.parse(task.listId),
        },
      );
      return _parseTaskFromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<TaskEntity> updateTask(TaskEntity task) async {
    try {
      final response = await _apiClient.put(
        '/tasks/${task.id}',
        data: {
          'title': task.title,
          'description': task.description,
          'is_completed': task.isCompleted,
          'due_date': task.dueDate?.toIso8601String(),
          'priority': task.priority,
          'task_list_id': int.parse(task.listId),
        },
      );
      return _parseTaskFromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _apiClient.delete('/tasks/$taskId');
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // Helper methods to parse JSON
  TaskListEntity _parseTaskListFromJson(Map<String, dynamic> json) {
    return TaskListEntity(
      id: json['id'].toString(),
      name: json['name'],
      color: json['color'],
      order: json['order'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  TaskEntity _parseTaskFromJson(Map<String, dynamic> json) {
    return TaskEntity(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      isCompleted: json['is_completed'] == 1 || json['is_completed'] == true,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'])
          : null,
      priority: json['priority'],
      listId: json['task_list_id'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
