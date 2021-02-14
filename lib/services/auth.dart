import 'package:anxi_pro/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String getCurrentUserUid() {
    return _auth.currentUser.uid;
  }

  AppUser _appUserFromFirebaseUser(User firebaseUser) {
    return firebaseUser != null ? AppUser(uid: firebaseUser.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _appUserFromFirebaseUser(userCredential.user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _appUserFromFirebaseUser(userCredential.user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
