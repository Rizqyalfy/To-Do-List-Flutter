import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'features/tasks/data/repositories/task_repository.dart';
import 'features/tasks/data/datasources/task_firebase_service.dart';
import 'features/tasks/domain/entities/task_list_entity.dart';
import 'features/tasks/presentation/bloc/task_bloc.dart';
import 'features/tasks/presentation/bloc/task_list_bloc.dart';
import 'features/tasks/presentation/bloc/task_list_event.dart';
import 'features/tasks/presentation/bloc/task_event.dart';
import 'features/tasks/presentation/screens/home_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/data/datasources/auth_firebase_service.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase if using firebase mode
  if (AppConstants.storageMode == 'firebase') {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Initialize repository with appropriate service
  final TaskRepository taskRepository;
  if (AppConstants.storageMode == 'firebase') {
    taskRepository = TaskRepository(firebaseService: TaskFirebaseService());
  } else {
    taskRepository = TaskRepository();
  }

  await taskRepository.initialize();

  // Create default list if none exists (for Firebase mode)
  if (AppConstants.storageMode == 'firebase') {
    final lists = await taskRepository.getAllTaskLists();
    if (lists.isEmpty) {
      await taskRepository.createTaskList(
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
          home: StreamBuilder(
            stream: AuthFirebaseService().authStateChanges,
            builder: (context, snapshot) {
              // Show loading while checking auth state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // If user is logged in, show home screen
              if (snapshot.hasData && snapshot.data != null) {
                return const HomeScreen();
              }

              // If user is not logged in, show login screen
              return const LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}
