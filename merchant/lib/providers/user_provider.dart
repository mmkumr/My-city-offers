import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Future<bool> updatePost(
    String url,
    String fileType,
    String promotionType,
    List categories,
    String days,
    List cities,
    List areas,
    String description,
    String uid,
  ) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      String id = Uuid().v1();
      await _firestore.collection('posts').doc(id).set({
        "time": FieldValue.serverTimestamp(),
        "id": id,
        "url": url,
        "fileType": fileType,
        'promotionType': promotionType,
        'categories': categories,
        'days': days,
        'cities': cities,
        "areas": areas,
        'description': description,
        "verified": "0",
        "userId": uid,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<DocumentSnapshot>> getPosts() {
    return _firestore
        .collection("posts")
        .where('userId', isEqualTo: user.uid)
        .get()
        .then((snap) {
      return snap.docs;
    });
  }

  deletePost(String id) {
    _firestore.collection("posts").doc(id).delete();
  }

  updatedate(String id, String days) {
    _firestore.collection("posts").doc(id).update({
      "vdate": FieldValue.delete(),
      "days": days,
      "verified": "0",
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
      Fluttertoast.showToast(msg: e.toString());
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
