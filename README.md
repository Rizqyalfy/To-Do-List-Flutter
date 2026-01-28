# To-Do List App - Google Tasks Clone

A beautiful and functional to-do list application built with Flutter + Laravel, inspired by Google Tasks. This app uses BLoC pattern for state management and supports both local storage (Hive) and API backend (Laravel + MySQL), running on Android and Web platforms.

## 🚀 Current Status

✅ **FULLY WORKING**
- Flutter app running on Chrome web (port auto-assigned)
- Laravel API server running at http://localhost:8000
- MySQL database configured with `todo_db`
- All migrations completed
- API integration tested and working
- Zero critical errors

## Features

- ✅ Create, read, update, and delete tasks
- 📝 Add task titles and descriptions
- 📅 Set due dates for tasks
- 🎯 Assign priority levels (None, Low, Medium, High)
- ✔️ Mark tasks as completed
- 📋 Organize tasks into multiple lists
- 💾 **Dual Mode**: Local storage (Hive) or API backend (Laravel)
- 🔄 Switchable between offline and online mode
- 🎨 Material Design 3 UI
- 🌓 Light and dark theme support
- 📱 Responsive design for mobile and web

## Architecture

This project follows Clean Architecture principles:

### Frontend (Flutter)
- **Domain Layer**: Entities representing business logic
- **Data Layer**: Models, repositories, API services, and data sources
- **Presentation Layer**: BLoC for state management, screens, and widgets

### Backend (Laravel API)
- **RESTful API** endpoints for CRUD operations
- **MySQL Database** with Laragon
- **Eloquent ORM** for database operations
- **API Resources** for data transformation

### Technologies Used

**Frontend:**
- Flutter - Cross-platform framework
- BLoC - State management pattern
- Hive - Lightweight local database
- Dio - HTTP client for API calls
- Equatable - Value equality for Dart classes

**Backend:**
- Laravel 10 - PHP framework
- MySQL - Relational database
- Laravel Sanctum - API authentication (ready)

## Project Structure

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Application                       │
│  (D:\Lamaran\Test AG Satu\)                                 │
├─────────────────────────────────────────────────────────────┤
│  lib/                                                        │
│  ├── core/                                                   │
│  │   ├── constants/    → App configuration                  │
│  │   ├── network/      → API client (Dio)                   │
│  │   └── theme/        → UI themes                          │
│  ├── features/tasks/                                         │
│  │   ├── data/                                               │
│  │   │   ├── datasources/  → API service                    │
│  │   │   ├── models/       → Hive models                    │
│  │   │   └── repositories/ → Data access layer              │
│  │   ├── domain/                                             │
│  │   │   └── entities/     → Business entities              │
│  │   └── presentation/                                       │
│  │       ├── bloc/         → BLoC pattern                   │
│  │       ├── screens/      → UI screens                     │
│  │       └── widgets/      → Reusable widgets               │
│  ├── main.dart            → Local storage mode              │
│  └── main_api.dart        → API mode                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    Laravel Backend API                       │
│  (D:\todo-api\)                                             │
├─────────────────────────────────────────────────────────────┤
│  app/                                                        │
│  ├── Http/Controllers/API/                                  │
│  │   ├── TaskController.php                                 │
│  │   └── TaskListController.php                             │
│  └── Models/                                                 │
│      ├── Task.php                                            │
│      └── TaskList.php                                        │
│  database/migrations/                                        │
│  ├── create_task_lists_table.php                            │
│  └── create_tasks_table.php                                 │
│  routes/                                                     │
│  └── api.php            → API routes                        │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites Checklist
- ✅ Flutter SDK (3.10.0+)
- ✅ Dart SDK (3.10.0+)  
- ✅ **Laragon** with MySQL (for API mode)
- ✅ **Composer** (for Laravel)
- ✅ VS Code or Android Studio

### Running the App (Full Stack - API Mode)

**1. Start Laravel Backend**
```bash
cd "D:\Lamaran\Test AG Satu\todo-api"

# Create database (first time only)
php create_db.php

# Run migrations (first time only)
php artisan migrate:fresh

# Start server
php artisan serve
```
✅ Server running at http://localhost:8000

**2. Start Flutter Frontend**
```bash
cd "D:\Lamaran\Test AG Satu\to do list-Flutter"

# Install dependencies (first time only)
flutter pub get

# Run on Chrome web
flutter run -d chrome lib/main_api.dart

# Or on Android device
flutter run -d <device-id> lib/main_api.dart
```

**3. Available Devices**
Check with: `flutter devices`
- Chrome (web) - ✅ Working
- ASUSAI2501B (Android 12) - ✅ Available
- Windows desktop - ⚠️ Not configured (add if needed)

### Alternative: Local Storage Only (No Backend)

```bash
cd "D:\Lamaran\Test AG Satu"

# Generate Hive adapters (first time only)
flutter pub run build_runner build --delete-conflicting-outputs

# Run local mode
flutter run -d chrome
```

## 📖 Documentation

- [TESTING_GUIDE.md](TESTING_GUIDE.md) - Complete testing procedures
- [FLUTTER_API_INTEGRATION.md](FLUTTER_API_INTEGRATION.md) - API integration details
- [LARAVEL_API_SETUP.md](LARAVEL_API_SETUP.md) - Laravel setup guide

### 📚 Documentation

Dokumentasi lengkap tersedia di:
- **[LARAVEL_API_SETUP.md](LARAVEL_API_SETUP.md)** - Panduan setup Laravel backend
- **[FLUTTER_API_INTEGRATION.md](FLUTTER_API_INTEGRATION.md)** - Panduan integrasi Flutter dengan API

### Running the App

#### Local Storage Mode (Offline)

Set `useApi = false` di `app_constants.dart`, then:

```bash
# Android
flutter run

# Web
flutter run -d chrome

# Select device
flutter devices
flutter run -d <device-id>
```

#### API Mode (Online - requires Laravel running)

Set `useApi = true` di `app_constants.dart`

**Important**: Pastikan Laravel API sudah running:
```bash
cd D:\todo-api
php artisan serve
```

Then run Flutter:
```bash
flutter run
```

**For Android Emulator**, use `10.0.2.2` instead of `localhost` in `app_constants.dart`:
```dart
static const String apiBaseUrl = 'http://10.0.2.2:8000/api';
```

**For Physical Device**, use your computer's IP:
```dart
static const String apiBaseUrl = 'http://192.168.1.100:8000/api';
```

## Usage

### Creating a Task
1. Tap the '+' floating action button
2. Enter task title (required)
3. Optionally add description, due date, and priority
4. Tap 'Add' to save

### Editing a Task
1. Tap on any task in the list
2. Modify the details
3. Tap 'Save' to update

### Completing a Task
- Tap the checkbox next to any task to mark it as complete/incomplete

### Deleting a Task
1. Tap on the task to open the edit dialog
2. Tap the delete icon in the top right
3. The task will be removed

### Managing Task Lists
1. Open the drawer by tapping the menu icon
2. Select a list to view its tasks
3. Tap 'New List' to create additional lists (coming soon)

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Web
```bash
flutter build web --release
```

The built files will be in:
- Android: `build/app/outputs/flutter-apk/`
- Web: `build/web/`

## Development

### Code Generation
When you modify data models with Hive annotations, regenerate the type adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting
Run static analysis:
```bash
flutter analyze
```

### Testing
Run tests:
```bash
flutter test
```

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3      # State management
  equatable: ^2.0.5         # Value equality
  hive: ^2.2.3              # Local storage
  hive_flutter: ^1.1.0      # Hive Flutter integration
  intl: ^0.19.0             # Internationalization
  uuid: ^4.3.3              # UUID generation
  dio: ^5.4.0               # HTTP client for API

dev_dependencies:
  build_runner: ^2.4.8      # Code generation
  hive_generator: ^2.0.1    # Hive type adapter generation
```

## API Endpoints (Laravel Backend)

When using API mode (`useApi = true`), the app connects to:

### Base URL
```
http://localhost:8000/api
```

### Task Lists
- **GET** `/task-lists` - Get all task lists
- **POST** `/task-lists` - Create new task list
  ```json
  {
    "name": "Work Tasks",
    "color": "#FF5733",
    "order": 0
  }
  ```
- **GET** `/task-lists/{id}` - Get specific task list
- **PUT/PATCH** `/task-lists/{id}` - Update task list
- **DELETE** `/task-lists/{id}` - Delete task list

### Tasks
- **GET** `/tasks?task_list_id={id}` - Get tasks (optional: filter by list)
- **POST** `/tasks` - Create new task
  ```json
  {
    "title": "Complete project",
    "description": "Finish the to-do list app",
    "is_completed": false,
    "due_date": "2026-02-01 10:00:00",
    "priority": 3,
    "task_list_id": 1
  }
  ```
- **GET** `/tasks/{id}` - Get specific task
- **PUT/PATCH** `/tasks/{id}` - Update task
- **DELETE** `/tasks/{id}` - Delete task

## Testing

### Test API dengan Postman/Thunder Client

1. Start Laravel server:
```bash
cd D:\todo-api
php artisan serve
```

2. Test endpoints:

**Create Task List:**
```http
POST http://localhost:8000/api/task-lists
Content-Type: application/json

{
  "name": "My Tasks",
  "order": 0
}
```

**Get All Tasks:**
```http
GET http://localhost:8000/api/tasks?task_list_id=1
```

### Test Flutter App

Run unit tests:
```bash
flutter test
```

Run widget tests:
```bash
flutter test test/widget_test.dart
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Inspired by Google Tasks
- Built with Flutter and BLoC pattern
- Uses Material Design 3 guidelines
