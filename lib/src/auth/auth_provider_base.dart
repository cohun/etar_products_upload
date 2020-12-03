import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthProviderBase {
  Future<FirebaseApp> initialize();

  Future<UserCredential> signInWithEmailAndPassword(String email, String password);

  Future<UserCredential> signInWithGoogle();

  Future<UserCredential> signInWithFacebook();
}
