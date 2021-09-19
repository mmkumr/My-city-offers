import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

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

  Future<bool> updateData(String photoUrl, String name, String email,
      String phone, String age, String gender, String uid) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firestore.collection('merchants').doc(uid).set({
        "photoUrl": photoUrl,
        "email": email,
        'name': name,
        'phone': phone,
        'age': age,
        'gender': gender,
        'userId': uid,
      });
      _userDetails = await _firestore
          .collection("merchants")
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
 
  Future<List<DocumentSnapshot>> getPosts(String type) {
    return _firestore
        .collection(type)
        .where('verified', isEqualTo: "true")
        .get()
        .then((snap) {
      return snap.docs;
    });
  }

  deletePost(String id, String type) {
    _firestore.collection(type).doc(id).delete();
  }

  Future<List<DocumentSnapshot>> postRequest(String type) {
    return _firestore
        .collection(type)
        .where('verified', isEqualTo: "0")
        .get()
        .then((snap) {
      return snap.docs;
    });
  }

  updateRequest(String id, String vdata, String type) {
    _firestore.collection(type).doc(id).update({
      "verified": vdata,
      "vdate": DateTime.now(),
    });
  }

  updateTop(List top, String type) {
    List ref = [];
    _firestore.collection(type).where("top", isEqualTo: true).get().then((value) {
      for (int i = 0; i < value.docs.length; ++i) {
        _firestore.collection(type).doc(value.docs[i].data()['id']).update({
          "top": false,
        });
      }
    });
    for (int i = 0; i < top.length; ++i) {
      var temp = _firestore.collection(type).doc(top[i]);
      temp.update({
        "top": true,
      });
      ref.insert(i, temp);
    }
    _firestore.collection("top" + type).doc("qunSkah202XkhkKPvPAW").update({
      "list": ref,
    });
  }
 

  Future<List> getTop(String type) {
    return _firestore.collection("top" + type).get().then((snap) {
      return snap.docs[0].data()["list"];
    });
  }


  addCategory(List category) {
    _firestore.collection("categories").doc("3fxDvAgSjUGYLROVD0Wm").update({
      "list": FieldValue.arrayUnion(category),
    });
  }

  updateCategory(List categories) {
    _firestore.collection("categories").doc("3fxDvAgSjUGYLROVD0Wm").update({
      "list": categories,
    });
  }

  Future<List> getCategories() {
    return _firestore.collection("categories").get().then((snap) {
      return snap.docs[0].data()["list"];
    });
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
          .collection("merchants")
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
          .collection("merchants")
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((value) {
        return value.docs.length;
      });
      if (userExist != 0) {
        _userDetails = await _firestore
            .collection("merchants")
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
