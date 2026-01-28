// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:todo_list_app/main.dart';
import 'package:todo_list_app/features/tasks/data/repositories/task_repository.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize repository
    final taskRepository = TaskRepository();
    await taskRepository.initialize();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(taskRepository: taskRepository));

    // Verify that app title is displayed
    expect(find.text('To-Do List'), findsOneWidget);
  });
}
