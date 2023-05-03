import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vbforntend/models/user.dart';
import 'package:vbforntend/routes/route_names.dart';

class UserProvider extends ChangeNotifier {
  late String? _authToken;
  late User _user;

  User? get user => _user;

  set setUser(User user) {
    _user = user;
    // notifyListeners();
  }

  String? get getToken => _authToken;

  set setToken(String token) {
    _authToken = token;
  }

  // Future<String?> getToken() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _authToken = prefs.getString('authToken');

  //   // return "bbb";
  //   return _authToken;
  // }

  // Future<User?> getUser() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? user = prefs.getString('user');
  //   if (user != null) {
  //     return Future.delayed(Duration(seconds: 0), () {
  //       _user = User.formJson(jsonDecode(user));
  //       return _user;
  //     });
  //   } else {
  //     return null;
  //   }
  // }

  Future<bool> saveUserWithToken(User userobj, String token) async {
    print("save user with token called");
    _user = userobj;
    _authToken = token;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(userobj.toMap()));
    await prefs.setString('authToken', token);
    // notifyListeners();
    return true;
  }

  Future<bool> saveUser(User user) async {
    _user = user;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString('user', jsonEncode(_user.toMap()));
    return result;
  }

  Future<bool> isUserLogged() async {
    print("is user logged called");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    String? token = prefs.getString('authToken');

    if (user != null && token != null) {
      print("inside if");
      // print("jsondec ${jsonDecode(user)}");
      Map<String, dynamic> usermap = jsonDecode(user) as Map<String, dynamic>;
      print(usermap);
      try {
        User a = User.formJson(usermap);
        print("user form : $a");
        _user = User.formJson(usermap);
        // print("Userinst: ${_user}");
        _authToken = token;
      } catch (error) {
        print(error);
        print('inside catch');
      }
      // print(token);

      // print("user from splash screen: $_user");
      // print("token form splash Screen: ${_authToken}");

      return true;
    }
    return false;
  }

  Future<bool> logout(BuildContext context) async {
    //after calling logut navigate to loginScreen form view
    //this function should be called when user logout or when UnAuthorized exception is thrown
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('user');
    Future.delayed(Duration(seconds: 0), () {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.loginScreen, (route) => false);
    });
    return true;
  }

  Future<bool> setKey(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString(key, value);
    return result;
  }

  Future<String?> getKeyValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? result = prefs.getString(key);
    return result;
  }
}
