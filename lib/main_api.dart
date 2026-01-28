import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/network/api_client.dart';
import 'core/constants/app_constants.dart';
import 'features/tasks/data/datasources/task_api_service.dart';
import 'features/tasks/data/repositories/task_repository.dart';
import 'features/tasks/presentation/bloc/task_bloc.dart';
import 'features/tasks/presentation/bloc/task_list_bloc.dart';
import 'features/tasks/presentation/bloc/task_list_event.dart';
import 'features/tasks/presentation/bloc/task_event.dart';
import 'features/tasks/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize repository
  TaskRepository taskRepository;

  if (AppConstants.useApi) {
    // Use API mode
    final apiClient = ApiClient();
    final apiService = TaskApiService(apiClient);
    taskRepository = TaskRepository(apiService: apiService);
  } else {
    // Use local storage mode
    taskRepository = TaskRepository();
  }

  await taskRepository.initialize();

  runApp(MyApp(taskRepository: taskRepository));
}

class MyApp extends StatelessWidget {
  final TaskRepository taskRepository;

  const MyApp({super.key, required this.taskRepository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: taskRepository)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                TaskListBloc(repository: taskRepository)..add(LoadTaskLists()),
          ),
          BlocProvider(
            create: (context) =>
                TaskBloc(repository: taskRepository)
                  ..add(const LoadTasks(AppConstants.defaultListId)),
          ),
        ],
        child: MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
