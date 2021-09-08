import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  late FirebaseAuth _auth;
  late User _user;
  late DocumentSnapshot _userDetails;
  Status _status = Status.Uninitialized;
  DocumentSnapshot get userDetails => _userDetails;
  Status get status => _status;
  User get user => _user;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleSignIn googleSignIn = new GoogleSignIn();

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> updateData(
      String photoUrl,
      String name,
      String email,
      String phone,
      String age,
      String area,
      String state,
      String gender,
      String uid) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firestore.collection('users').doc(uid).set({
        "photoUrl": photoUrl,
        "email": email,
        'name': name,
        'phone': phone,
        'age': age,
        'area': area,
        'city': state,
        'gender': gender,
        'userId': uid,
      });
      _userDetails = await _firestore
          .collection("users")
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((value) {
        return value.docs[0];
      });
      _status = Status.Authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential authResult = await _auth.signInWithCredential(credential);
      int userExist = await _firestore
          .collection("users")
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((value) {
        return value.docs.length;
      });
      if (userExist == 0) {
        _status = Status.Authenticating;
        notifyListeners();
        return "new";
      }
      _status = Status.Authenticated;
      notifyListeners();
      return "old";
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return "fail";
    }
  }

  signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  Future<void> _onStateChanged(User? user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      int userExist = await _firestore
          .collection("users")
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((value) {
        return value.docs.length;
      });
      if (userExist != 0) {
        _userDetails = await _firestore
            .collection("users")
            .where('userId', isEqualTo: user.uid)
            .get()
            .then((value) {
          return value.docs[0];
        });
      }
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
