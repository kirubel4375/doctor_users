import 'package:firebase_auth/firebase_auth.dart';
class AuthenticationService{
  AuthenticationService(this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  Future<String?> signIn ({required String email, required String password})async{
    try{
       await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
       return "sign in successful";
    }on FirebaseAuthException catch(e){
      return e.message;
    }

  }
  Future<String?> signUp({required String email, required String password})async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "sign up successful";
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
}