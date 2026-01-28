import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Update display name
  Future<void> updateDisplayName(String displayName) async {
    await currentUser?.updateDisplayName(displayName);
  }

  // Get error message
  String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Email tidak terdaftar';
        case 'wrong-password':
          return 'Password salah';
        case 'email-already-in-use':
          return 'Email sudah digunakan';
        case 'weak-password':
          return 'Password terlalu lemah';
        case 'invalid-email':
          return 'Email tidak valid';
        case 'user-disabled':
          return 'Akun telah dinonaktifkan';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan, coba lagi nanti';
        default:
          return error.message ?? 'Terjadi kesalahan';
      }
    }
    return error.toString();
  }
}
