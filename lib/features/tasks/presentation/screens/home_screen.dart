import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_state.dart';
import '../bloc/task_list_bloc.dart';
import '../bloc/task_list_state.dart';
import '../bloc/task_list_event.dart';
import '../widgets/task_list_item.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_list_drawer.dart';
import '../widgets/add_list_dialog.dart';
import '../../../../core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TaskListBloc, TaskListState>(
          builder: (context, state) {
            if (state is TaskListLoaded &&
                state.selectedListId != null &&
                state.taskLists.isNotEmpty) {
              final selectedList = state.taskLists.firstWhere(
                (list) => list.id == state.selectedListId,
                orElse: () => state.taskLists.first,
              );
              return Text(selectedList.name);
            }
            return const Text(AppConstants.appName);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
      drawer: const TaskListDrawer(),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tasks yet',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add a new task',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              );
            }

            final incompleteTasks = state.tasks
                .where((task) => !task.isCompleted)
                .toList();
            final completedTasks = state.tasks
                .where((task) => task.isCompleted)
                .toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (incompleteTasks.isNotEmpty) ...[
                  ...incompleteTasks.map(
                    (task) => TaskListItem(
                      task: task,
                      onTap: () => _showTaskDetail(context, task),
                    ),
                  ),
                ],
                if (completedTasks.isNotEmpty) ...[
                  if (incompleteTasks.isNotEmpty) const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Completed (${completedTasks.length})',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  ...completedTasks.map(
                    (task) => TaskListItem(
                      task: task,
                      onTap: () => _showTaskDetail(context, task),
                    ),
                  ),
                ],
              ],
            );
          } else if (state is TaskError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Welcome!'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<TaskBloc>(),
        child: const AddTaskDialog(),
      ),
    );
  }

  void _showTaskDetail(BuildContext context, dynamic task) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<TaskBloc>(),
        child: AddTaskDialog(task: task),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          if (state is! TaskListLoaded) {
            return const SizedBox.shrink();
          }

          final selectedList = state.taskLists.firstWhere(
            (list) => list.id == state.selectedListId,
            orElse: () => state.taskLists.first,
          );

          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Edit List'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (dialogContext) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<TaskListBloc>(),
                          ),
                        ],
                        child: AddListDialog(taskList: selectedList),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Delete List'),
                  enabled: state.taskLists.length > 1,
                  onTap: state.taskLists.length > 1
                      ? () {
                          Navigator.pop(context);
                          _showDeleteConfirmation(context, selectedList.id);
                        }
                      : null,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.sort_outlined),
                  title: const Text('Sort Tasks'),
                  onTap: () {
                    Navigator.pop(context);
                    _showSortOptions(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outlined),
                  title: const Text('About'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutInfo(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String listId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete List'),
        content: const Text(
          'Are you sure you want to delete this list? All tasks in this list will also be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<TaskListBloc>().add(DeleteTaskList(listId));
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('By Due Date'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sorting by due date...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('By Priority'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sorting by priority...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('By Name'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sorting by name...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutInfo(BuildContext context) {
    final taskListBloc = context.read<TaskListBloc>();
    final taskBloc = context.read<TaskBloc>();

    int totalLists = 0;
    int totalTasks = 0;
    int completedTasks = 0;

    final taskListState = taskListBloc.state;
    if (taskListState is TaskListLoaded) {
      totalLists = taskListState.taskLists.length;
    }

    final taskState = taskBloc.state;
    if (taskState is TaskLoaded) {
      totalTasks = taskState.tasks.length;
      completedTasks = taskState.tasks.where((t) => t.isCompleted).length;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatItem(context, 'Total Lists', totalLists.toString()),
            const SizedBox(height: 8),
            _buildStatItem(context, 'Total Tasks', totalTasks.toString()),
            const SizedBox(height: 8),
            _buildStatItem(context, 'Completed', completedTasks.toString()),
            const SizedBox(height: 8),
            _buildStatItem(
              context,
              'Remaining',
              (totalTasks - completedTasks).toString(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
