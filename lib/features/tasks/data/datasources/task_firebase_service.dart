import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_list_entity.dart';

class TaskFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to collections
  CollectionReference get _taskListsCollection =>
      _firestore.collection('task_lists');
  CollectionReference get _tasksCollection => _firestore.collection('tasks');

  // Task List Operations
  Future<void> createTaskList(TaskListEntity taskList) async {
    await _taskListsCollection.doc(taskList.id).set({
      'id': taskList.id,
      'name': taskList.name,
      'color': taskList.color,
      'order': taskList.order,
      'createdAt': Timestamp.fromDate(taskList.createdAt),
      'updatedAt': Timestamp.fromDate(taskList.updatedAt),
    });
  }

  Future<void> updateTaskList(TaskListEntity taskList) async {
    await _taskListsCollection.doc(taskList.id).update({
      'name': taskList.name,
      'color': taskList.color,
      'order': taskList.order,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> deleteTaskList(String taskListId) async {
    // Delete all tasks in this list first
    final tasksSnapshot = await _tasksCollection
        .where('listId', isEqualTo: taskListId)
        .get();

    final batch = _firestore.batch();
    for (var doc in tasksSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Delete the list itself
    batch.delete(_taskListsCollection.doc(taskListId));

    await batch.commit();
  }

  Future<List<TaskListEntity>> getAllTaskLists() async {
    final snapshot = await _taskListsCollection.orderBy('order').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return TaskListEntity(
        id: data['id'] as String,
        name: data['name'] as String,
        color: data['color'] as String?,
        order: data['order'] as int,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Stream<List<TaskListEntity>> watchTaskLists() {
    return _taskListsCollection
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return TaskListEntity(
              id: data['id'] as String,
              name: data['name'] as String,
              color: data['color'] as String?,
              order: data['order'] as int,
              createdAt: (data['createdAt'] as Timestamp).toDate(),
              updatedAt: (data['updatedAt'] as Timestamp).toDate(),
            );
          }).toList(),
        );
  }

  // Task Operations
  Future<void> createTask(TaskEntity task) async {
    await _tasksCollection.doc(task.id).set({
      'id': task.id,
      'listId': task.listId,
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted,
      'dueDate': task.dueDate != null
          ? Timestamp.fromDate(task.dueDate!)
          : null,
      'priority': task.priority,
      'createdAt': Timestamp.fromDate(task.createdAt),
      'updatedAt': Timestamp.fromDate(task.updatedAt),
    });
  }

  Future<void> updateTask(TaskEntity task) async {
    await _tasksCollection.doc(task.id).update({
      'listId': task.listId,
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted,
      'dueDate': task.dueDate != null
          ? Timestamp.fromDate(task.dueDate!)
          : null,
      'priority': task.priority,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  Future<List<TaskEntity>> getTasksByList(String listId) async {
    final snapshot = await _tasksCollection
        .where('listId', isEqualTo: listId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return TaskEntity(
        id: data['id'] as String,
        listId: data['listId'] as String,
        title: data['title'] as String,
        description: data['description'] as String? ?? '',
        isCompleted: data['isCompleted'] as bool,
        dueDate: data['dueDate'] != null
            ? (data['dueDate'] as Timestamp).toDate()
            : null,
        priority: data['priority'] as int,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Stream<List<TaskEntity>> watchTasksByList(String listId) {
    return _tasksCollection
        .where('listId', isEqualTo: listId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return TaskEntity(
              id: data['id'] as String,
              listId: data['listId'] as String,
              title: data['title'] as String,
              description: data['description'] as String? ?? '',
              isCompleted: data['isCompleted'] as bool,
              dueDate: data['dueDate'] != null
                  ? (data['dueDate'] as Timestamp).toDate()
                  : null,
              priority: data['priority'] as int,
              createdAt: (data['createdAt'] as Timestamp).toDate(),
              updatedAt: (data['updatedAt'] as Timestamp).toDate(),
            );
          }).toList(),
        );
  }

  // Statistics
  Future<int> getTotalTasksCount(String listId) async {
    final snapshot = await _tasksCollection
        .where('listId', isEqualTo: listId)
        .get();
    return snapshot.docs.length;
  }

  Future<int> getCompletedTasksCount(String listId) async {
    final snapshot = await _tasksCollection
        .where('listId', isEqualTo: listId)
        .where('isCompleted', isEqualTo: true)
        .get();
    return snapshot.docs.length;
  }
}
