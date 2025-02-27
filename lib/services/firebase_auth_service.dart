import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseAuthService() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        print("User is signed out");
      } else {
        print("User is signed in: ${user.email}");
      }
    });
  }

  Future<Result<User>> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.success(userCredential.user);
    } catch (e) {
      return Result.error("Sign up error: $e");
    }
  }

  Future<Result<User>> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.success(userCredential.user);
    } catch (e) {
      return Result.error("Sign in error: $e");
    }
  }

  Future<Result<User>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) {
        return Result.error("Google authentication failed");
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return Result.success(userCredential.user);
    } catch (e) {
      return Result.error("Google Sign-In error: $e");
    }
  }
}

class Result<T> {
  final T? data;
  final String? error;

  Result.success(this.data) : error = null;
  Result.error(this.error) : data = null;

  bool get isSuccess => data != null;
  bool get isError => error != null;
}
