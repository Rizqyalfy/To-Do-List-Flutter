# To-Do List App - Google Tasks Clone

Aplikasi daftar tugas dan fungsional yang dibangun dengan Flutter + Firebase, terinspirasi oleh Google Tasks. Aplikasi ini menggunakan pola BLoC untuk manajemen state dengan Firebase Authentication dan Cloud Firestore untuk penyimpanan cloud real-time, berjalan di platform Android dan Web.

## 🚀 Current Status

✅ **FULLY WORKING**
- Flutter app with Firebase Authentication
- Cloud Firestore for real-time data sync
- User registration and login system
- Secure authentication with email/password
- Real-time task synchronization across devices
- Zero critical errors


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
│  (D:...\Test AG Satu\to do list-Flutter)               │
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

