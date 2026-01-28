class AppConstants {
  // App Info
  static const String appName = 'To-Do List';
  static const String appVersion = '1.0.0';

  // Storage Mode: 'hive', 'firebase', or 'api'
  static const String storageMode =
      'firebase'; // Change to 'hive' or 'api' as needed

  // API Configuration (for 'api' mode)
  static const String apiBaseUrl = 'http://localhost:8000/api';
  static const bool useApi = false; // Deprecated: use storageMode instead

  // Storage Keys (for 'hive' mode)
  static const String taskBoxName = 'tasks';
  static const String taskListBoxName = 'task_lists';
  static const String settingsBoxName = 'settings';

  // Default Values
  static const String defaultListName = 'My Tasks';
  static const String defaultListId = 'default_list';

  // Date Format
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd MMM yyyy HH:mm';
}
