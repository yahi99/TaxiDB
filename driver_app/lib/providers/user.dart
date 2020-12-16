import 'dart:async';

import 'package:dio/dio.dart';
import 'package:driver_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../helpers/constants.dart';
import '../models/user.dart';
import '../services/user.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  User _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  UserModel _userModel;
  int _carId;

  // getter
  UserModel get userModel => _userModel;
  Status get status => _status;
  User get user => _user;

  // public variables
  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController car = TextEditingController();
  TextEditingController plate = TextEditingController();
  TextEditingController passport = TextEditingController();
  TextEditingController driveLicense = TextEditingController();

  UserProvider.initialize() {
    _fireSetUp();
  }

  _fireSetUp() async {
    await initialization.then((value) {
      auth.authStateChanges().listen(_onStateChanged);
    });
  }

  Future<bool> signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((value) async {
        await prefs.setString("id", value.user.uid);
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(Position position) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("id", result.user.uid);
        String _deviceToken = await fcm.getToken();
        var dioRequest = Dio();
        await dioRequest.post(
          apiUrl + '/register_driver_and_car',
          data: {
            'login': Uuid().v4(),
            'name': name.text.trim(),
            'phone': phone.text.trim(),
            'password': password.text.trim(),
            'license': driveLicense.text.trim(),
            'car_gos_number': plate.text.trim(),
            'car_category': 'Комфорт',
            'car_model': car.text.split(' ')[0],
            'car_number_seats': 4,
            'car_mark': car.text.split(' ')[1],
            'car_color': 'Синий',
            'passport': passport.text.trim(),
          },
        ).then((value) {
          _carId = value.data['car_id'];
          print(value);
        });
        _userServices.createUser(
          dbId: _carId.toString(),
          id: result.user.uid,
          name: name.text.trim(),
          email: email.text.trim(),
          phone: phone.text.trim(),
          position: position.toJson(),
          token: _deviceToken,
          car: car.text.trim(),
          plate: plate.text.trim(),
          driveLicense: driveLicense.text.trim(),
          passport: passport.text.trim(),
        );
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    auth.signOut();
    _status = Status.Unauthenticated;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("id");
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    email.text = "";
    password.text = "";
    name.text = "";
    phone.text = "";
    car.text = "";
    plate.text = "";
    passport.text = "";
    driveLicense.text = "";
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

  _onStateChanged(User firebaseUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      await prefs.setString("id", firebaseUser.uid);

      _userModel = await _userServices.getUserById(user.uid).then((value) {
        _status = Status.Authenticated;
        return value;
      });
    }
    notifyListeners();
  }
}
