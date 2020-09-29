import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sembast/sembast.dart';
import 'dart:convert';

import 'package:cat_app/widgets/notification_text.dart';
import 'package:cat_app/providers/database.dart';
import 'package:cat_app/models/user.dart';
import 'dart:developer';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {

  Status _status = Status.Uninitialized;
  NotificationText _notification;
  User _loggedInUser;

  Status get status => _status;
  String get user => _loggedInUser.name;
  NotificationText get notification => _notification;
  Database db;

  final String api = 'https://laravelreact.com/api/v1/auth';

  initAuthProvider() async {
    db = await DatabaseProvider.dbProvider.database;
    User user = await getLoggedInUser();
    bool isAuthenticate = await DatabaseProvider.dbProvider.authenciateLoggedInUser(user);
    if (isAuthenticate) {
      _loggedInUser = user;
      _status = Status.Authenticated;
    } else {
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = Status.Authenticating;
    _notification = null;
    notifyListeners();
    bool isSuccess = await  DatabaseProvider.dbProvider.authenticateUser(email, password);

    if(isSuccess){
      _status = Status.Authenticated;
      User loggedInUser = User(name:email,password:password);
      await storeUserData(loggedInUser.toJson());
      notifyListeners();
      return true;
    }

    _status = Status.Unauthenticated;
    _notification = NotificationText('email atau password salah');
    notifyListeners();
    return false;
  }

  Future<Map> register(String name, String email, String password, String passwordConfirm) async {
    Map<String, String> body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirm,
    };

    Map<String, dynamic> result = {
      "success": false,
      "message": 'Unknown error.'
    };

    // final response = await http.post( url, body: body, );
    final response = await DatabaseProvider.dbProvider.registerNewUser(body);
    if (response == 200) {
      _notification = NotificationText('Registration successful, please log in.', type: 'info');
      notifyListeners();
      result['success'] = true;
      return result;
    }

    // Map apiResponse = json.decode(response.body);

    if (response == 422) {
      _notification = NotificationText('Registration failed', type: 'info');
      notifyListeners();
      result['success'] = false;
      return result;
    }
    //   if (apiResponse['errors'].containsKey('email')) {
    //     result['message'] = apiResponse['errors']['email'][0];
    //     return result;
    //   }

    //   if (apiResponse['errors'].containsKey('password')) {
    //     result['message'] = apiResponse['errors']['password'][0];
    //     return result;
    //   }

    //   return result;
    // }

    return result;
  }

  Future<bool> passwordReset(String email) async {
    final url = "$api/forgot-password";

    Map<String, String> body = {
      'email': email,
    };

    // final response = await http.post( url, body: body, );

    // if (response.statusCode == 200) {
    //   _notification = NotificationText('Reset sent. Please check your inbox.', type: 'info');
    //   notifyListeners();
    //   return true;
    // }

    return false;
  }

  storeUserData(apiResponse) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('account', apiResponse['email']);
    await storage.setString('password', apiResponse['password']);
  }

  Future<User> getLoggedInUser() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String user = storage.getString('account');
    String password = storage.getString('password');
    return User(name: user, password: password);
  }

  logOut([bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    if (tokenExpired == true) {
      _notification = NotificationText('Session expired. Please log in again.', type: 'info');
    }
    notifyListeners();

    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
  }

}