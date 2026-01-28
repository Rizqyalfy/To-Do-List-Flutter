import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_list_bloc.dart';
import '../bloc/task_list_state.dart';
import '../bloc/task_list_event.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../../data/repositories/task_repository.dart';
import 'add_list_dialog.dart';
import '../screens/settings_screen.dart';

class TaskListDrawer extends StatelessWidget {
  const TaskListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          if (state is TaskListLoaded) {
            return Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.checklist,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'To-Do List',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.taskLists.length,
                    itemBuilder: (context, index) {
                      final taskList = state.taskLists[index];
                      final isSelected = taskList.id == state.selectedListId;
                      final repository = context.read<TaskRepository>();

                      return FutureBuilder<Map<String, int>>(
                        future:
                            Future.wait([
                              repository.getTotalTasksCount(taskList.id),
                              repository.getCompletedTasksCount(taskList.id),
                            ]).then(
                              (counts) => {
                                'total': counts[0],
                                'completed': counts[1],
                              },
                            ),
                        builder: (context, snapshot) {
                          final taskCount = snapshot.data?['total'] ?? 0;
                          final completedCount =
                              snapshot.data?['completed'] ?? 0;

                          return ListTile(
                            selected: isSelected,
                            leading: Icon(
                              Icons.list,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            title: Text(taskList.name),
                            subtitle: Text(
                              '$completedCount / $taskCount tasks',
                            ),
                            onTap: () {
                              context.read<TaskListBloc>().add(
                                SelectTaskList(taskList.id),
                              );
                              context.read<TaskBloc>().add(
                                LoadTasks(taskList.id),
                              );
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('New List'),
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (dialogContext) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<TaskListBloc>(),
                          ),
                        ],
                        child: const AddListDialog(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
