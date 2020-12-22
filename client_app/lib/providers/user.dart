import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_client/constants.dart';
import 'package:taxi_client/helpers/constants.dart';
import 'package:taxi_client/models/user.dart';
import 'package:taxi_client/services/user.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  static const LOGGED_IN = "loggedIn";
  static const ID = "id";

  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  UserModel _userModel;
  String _userDbId;

  //  getter
  UserModel get userModel => _userModel;
  Status get status => _status;
  FirebaseUser get user => _user;

  // public variables
  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  UserProvider.initialize() {
    _initialize();
  }

  Future<bool> signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _status = Status.Authenticating;
    notifyListeners();
    await auth
        .signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim())
        .then((value) async {
      await prefs.setString(ID, value.user.uid);
      await prefs.setBool(LOGGED_IN, true);

      _userModel = await _userServices.getUserById(value.user.uid);
    });
    return true;
  }

  Future<bool> signUp() async {
    _status = Status.Authenticating;
    notifyListeners();
    await auth
        .createUserWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim())
        .then((result) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(ID, result.user.uid);
      await prefs.setBool(LOGGED_IN, true);
      var dioRequest = Dio();
      await dioRequest.post(
        "http://" + apiUrl + '/register_user',
        data: {
          'login': result.user.uid,
          'name': name.text.trim(),
          'phone': phone.text.trim(),
          'password': password.text.trim(),
        },
      ).then((value) => _userDbId = value.data['client_id']);
      _userServices.createUser(
        id: result.user.uid,
        dbId: _userDbId,
        name: name.text.trim(),
        email: email.text.trim(),
        phone: phone.text.trim(),
      );
      await prefs.setString(ID, result.user.uid);
      await prefs.setBool(LOGGED_IN, true);
      _userModel = await _userServices.getUserById(result.user.uid);
    });
    return true;
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    auth.signOut();
    _status = Status.Unauthenticated;
    await prefs.setString(ID, null);
    await prefs.setBool(LOGGED_IN, false);
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    name.text = "";
    password.text = "";
    email.text = "";
    phone.text = "";
  }

  Future<void> reloadUserModel() async {
    _userModel = await _userServices.getUserById(user.uid);
    notifyListeners();
  }

  updateUserData(Map<String, dynamic> data) async {
    _userServices.updateUserData(data);
  }

  saveDeviceToken() async {
    String deviceToken = await fcm.getToken();
    if (deviceToken != null) {
      _userServices.addDeviceToken(userId: user.uid, token: deviceToken);
    }
  }

  _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool(LOGGED_IN) ?? false;
    if (!loggedIn) {
      _status = Status.Unauthenticated;
    } else {
      await auth.currentUser().then((currentUser) async {
        _user = currentUser;
        _status = Status.Authenticated;
        _userModel = await _userServices.getUserById(currentUser.uid);
      });
    }
    notifyListeners();
  }
}
