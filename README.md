# To-Do List App - Google Tasks Clone

A beautiful and functional to-do list application built with Flutter + Firebase, inspired by Google Tasks. This app uses BLoC pattern for state management with Firebase Authentication and Cloud Firestore for real-time cloud storage, running on Android and Web platforms.

## 🚀 Current Status

✅ **FULLY WORKING**
- Flutter app with Firebase Authentication
- Cloud Firestore for real-time data sync
- User registration and login system
- Secure authentication with email/password
- Real-time task synchronization across devices
- Zero critical errors

## Features

- 🔐 **User Authentication** - Secure login and registration
- ✅ Create, read, update, and delete tasks
- 📝 Add task titles and descriptions
- 📅 Set due dates for tasks
- 🎯 Assign priority levels (None, Low, Medium, High)
- ✔️ Mark tasks as completed
- 📋 Organize tasks into multiple lists
- ☁️ **Cloud Storage** with Firebase Firestore
- 🔄 Real-time sync across multiple devices
- 👤 User profile management with logout
- 🎨 Material Design 3 UI
- 🌓 Light and dark theme support
- 📱 Responsive design for mobile and web

## Architecture

This project follows Clean Architecture principles:

### Frontend (Flutter)
- **Domain Layer**: Entities representing business logic
- **Data Layer**: Models, repositories, Firebase services, and data sources
- **Presentation Layer**: BLoC for state management, screens, and widgets

### Backend (Firebase)
- **Firebase Authentication** - Secure user login/registration
- **Cloud Firestore** - NoSQL cloud database with real-time sync
- **Firebase Console** - Backend management and monitoring

### Technologies Used

**Frontend:**
- Flutter - Cross-platform framework
- BLoC - State management pattern
- Firebase Core - Firebase initialization
- Firebase Auth - User authentication
- Cloud Firestore - Real-time database
- Equatable - Value equality for Dart classes

**Backend:**
- Firebase Authentication - User management
- Cloud Firestore - NoSQL database
- Firebase Security Rules - Data access control

## Project Structure

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Application                       │
│  (D:\Lamaran\Test AG Satu\to do list-Flutter)               │
├─────────────────────────────────────────────────────────────┤
│  lib/                                                        │
│  ├── core/                                                   │
│  │   ├── constants/    → App configuration                  │
│  │   └── theme/        → UI themes                          │
│  ├── features/                                               │
│  │   ├── auth/                                               │
│  │   │   ├── data/                                           │
│  │   │   │   └── datasources/ → Firebase Auth service       │
│  │   │   └── presentation/                                   │
│  │   │       └── screens/   → Login & Register              │
│  │   └── tasks/                                              │
│  │       ├── data/                                           │
│  │       │   ├── datasources/  → Firebase service           │
│  │       │   └── repositories/ → Data access layer          │
│  │       ├── domain/                                         │
│  │       │   └── entities/     → Business entities          │
│  │       └── presentation/                                   │
│  │           ├── bloc/         → BLoC pattern               │
│  │           ├── screens/      → UI screens                 │
│  │           └── widgets/      → Reusable widgets           │
│  ├── firebase_options.dart   → Firebase configuration       │
│  └── main.dart               → App entry point              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    Firebase Backend                          │
│  (Cloud - firebase.google.com)                              │
├─────────────────────────────────────────────────────────────┤
│  Firebase Authentication                                     │
│  └── Email/Password authentication enabled                  │
│                                                              │
│  Cloud Firestore Collections                                │
│  ├── task_lists/                                             │
│  │   ├── id (String)                                         │
│  │   ├── name (String)                                       │
│  │   ├── color (String)                                      │
│  │   ├── order (Number)                                      │
│  │   ├── createdAt (Timestamp)                               │
│  │   └── updatedAt (Timestamp)                               │
│  └── tasks/                                                  │
│      ├── id (String)                                         │
│      ├── listId (String)                                     │
│      ├── title (String)                                      │
│      ├── description (String)                                │
│      ├── isCompleted (Boolean)                               │
│      ├── dueDate (Timestamp)                                 │
│      ├── priority (Number)                                   │
│      ├── createdAt (Timestamp)                               │
│      └── updatedAt (Timestamp)                               │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites Checklist
- ✅ Flutter SDK (3.10.0+)
- ✅ Dart SDK (3.10.0+)  
- ✅ Firebase account (free tier)
- ✅ VS Code or Android Studio

### Setup Firebase Project

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Add project" and follow the wizard

2. **Enable Authentication**
   - In Firebase Console → Authentication
   - Click "Get started"
   - Enable "Email/Password" sign-in method

3. **Create Firestore Database**
   - In Firebase Console → Firestore Database
   - Click "Create database"
   - Start in test mode (for development)
   - Choose your preferred region

4. **Register Flutter App**
   - Use FlutterFire CLI for easy setup:
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your Flutter app
   dart pub global run flutterfire_cli:flutterfire configure --project=your-project-id
   ```

### Running the App

```bash
cd "D:\Lamaran\Test AG Satu\to do list-Flutter"

# Install dependencies (first time only)
flutter pub get

# Run on Chrome web
flutter run -d chrome

# Or on Android device
flutter run -d <device-id>
```

### First Time Usage

1. **Register Account**
   - Open the app, you'll see the login screen
   - Click "Belum punya akun? Daftar"
   - Fill in your name, email, and password
   - Click "Daftar" to create your account

2. **Login**
   - Use your registered email and password
   - Click "Masuk" to login

3. **Start Using**
   - Create task lists in the drawer
   - Add tasks with the '+' button
   - Your data syncs automatically to the cloud!

## 📖 Documentation

For detailed setup and configuration, check these guides:
- Setup instructions for Firebase configuration
- Security rules for Firestore
- Authentication flow details

## Usage

### First Login / Register
1. Open the app for the first time
2. Click "Belum punya akun? Daftar" to register
3. Fill in your name, email, and password
4. After registration, you'll be automatically logged in

### Creating a Task
1. Tap the '+' floating action button
2. Enter task title (required)
3. Optionally add description, due date, and priority
4. Tap 'Add' to save (syncs to cloud automatically)

### Editing a Task
1. Tap on any task in the list
2. Modify the details
3. Tap 'Save' to update (syncs instantly)

### Completing a Task
- Tap the checkbox next to any task to mark it as complete/incomplete
- Changes sync in real-time across all your devices

### Deleting a Task
1. Tap on the task to open the edit dialog
2. Tap the delete icon in the top right
3. The task will be removed from cloud

### Managing Task Lists
1. Open the drawer by tapping the menu icon
2. Select a list to view its tasks
3. Tap 'New List' to create additional lists
4. All lists sync across devices

### User Profile & Logout
1. Open Settings from the three-dot menu
2. View your profile information
3. Click "Logout" to sign out
4. You'll be redirected to login screen

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

### Firebase Configuration
The Firebase configuration is stored in `lib/firebase_options.dart`. This file contains your Firebase project credentials and should not be committed to public repositories.

To reconfigure Firebase:
```bash
dart pub global run flutterfire_cli:flutterfire configure
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
  flutter_bloc: ^8.1.6      # State management
  equatable: ^2.0.5         # Value equality
  intl: ^0.19.0             # Internationalization
  uuid: ^4.3.3              # UUID generation
  
  # Firebase
  firebase_core: ^2.32.0    # Firebase SDK core
  cloud_firestore: ^4.17.5  # Cloud Firestore database
  firebase_auth: ^4.20.0    # Firebase Authentication

dev_dependencies:
  flutter_test:
    sdk: flutter
```

## Firebase Services

### Authentication
The app uses Firebase Authentication with Email/Password:
- User registration with name, email, password
- Secure login with email/password
- Password validation (min 6 characters)
- Automatic session management
- Logout functionality

### Cloud Firestore Structure

**Collections:**

1. **task_lists** - Stores all task lists
   ```json
   {
     "id": "uuid-string",
     "name": "My Tasks",
     "color": "#FF5733",
     "order": 0,
     "createdAt": "Timestamp",
     "updatedAt": "Timestamp"
   }
   ```

2. **tasks** - Stores all tasks
   ```json
   {
     "id": "uuid-string",
     "listId": "task-list-uuid",
     "title": "Complete project",
     "description": "Finish the to-do list app",
     "isCompleted": false,
     "dueDate": "Timestamp",
     "priority": 3,
     "createdAt": "Timestamp",
     "updatedAt": "Timestamp"
   }
   ```

### Security Rules

For development, use test mode rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

For production, implement proper security rules based on user ownership.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Inspired by Google Tasks
- Built with Flutter and BLoC pattern
- Powered by Firebase (Authentication & Firestore)
- Uses Material Design 3 guidelines
