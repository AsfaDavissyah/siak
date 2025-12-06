import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // REGISTER USER (email + password)
  Future<User?> registerUser({
    required String email,
    required String password,
  }) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return cred.user;
  }

  // LOGIN USER
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return cred.user;
  }

  // LOGOUT
  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  // CHECK CURRENT USER
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
