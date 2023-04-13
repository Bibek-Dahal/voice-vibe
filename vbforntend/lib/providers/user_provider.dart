import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vbforntend/models/user.dart';

class UserProvider extends ChangeNotifier {
  late String? _authToken;
  late User? _user;

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('authToken');

    // return "bbb";
    return _authToken;
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      _user = User.formJson(jsonDecode(user));
      return _user;
    } else {
      return null;
    }
  }

  Future<bool> saveUser(User user, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toMap()));
    await prefs.setString('authToken', token);
    return true;
  }

  Future<bool> logout() async {
    //after calling logut navigate to loginScreen form view
    //this function should be called when user logout or when UnAuthorized exception is thrown
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('user');
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
