import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/data/app_exception.dart';
import 'package:vbforntend/data/response/api_response.dart';
import 'package:vbforntend/repository/auth_repository.dart';
import 'package:vbforntend/routes/route_names.dart';
import 'package:vbforntend/utils/lodable.dart';
import 'package:vbforntend/utils/utils.dart';
import 'package:vbforntend/models/user.dart';
import 'package:vbforntend/providers/user_provider.dart';

class AuthController extends ChangeNotifier {
  AuthRepository authRepo = AuthRepository();
  late ApiResponse apiResponse;
  bool isLoading = false;

  setIsLoading(bool value) {
    notifyListeners();
  }

  setResponse() {}

  Future<void> register(BuildContext context, dynamic data) async {
    setIsLoading(true);
    try {
      dynamic res = await authRepo.signup(data);
      setIsLoading(false);
      Future.delayed(const Duration(microseconds: 500), () {
        print("navigation called");
        Navigator.pushReplacementNamed(context, RouteName.otpScreen,
            arguments: res['data']);
        Utils.showSnackBar(context, res['message']);
      });
    } catch (error) {
      setIsLoading(false);
      // print("register error: $error");
      // print(error);
      if (error is AppException) {
        // print(error);

        // var e = error.error;

        // if (e is List) {
        //   print(true);
        // }
        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
      // print("outside if");
      // Utils.showSnackBar(context, error.toString());
    }
  }

  Future<void> login(BuildContext context, Map<String, dynamic> body) async {
    setIsLoading(true);
    try {
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      dynamic res = await authRepo.login(body);

      // String authToken = res.remove('authToken');
      print(res['data']);
      var created_at = res['data']['created_at'];
      print(created_at.runtimeType);

      print("hello");
      // print("user: ${User.formJson(res['data'])}");

      await userProvider.saveUserWithToken(
          User.formJson(res['data']), res['auth_token']);

      Future.delayed(const Duration(seconds: 0), () {
        Navigator.pushReplacementNamed(context, RouteName.homeScreen);
      });
    } catch (error) {
      setIsLoading(false);
      // print("register error: $error");
      // print(error);

      if (error is AppException) {
        print("inside app exception: ${error.error}");
        //Note if userUnverified exception occour push screen to OTP verification screen

        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }

  //sends OTP with phone num
  Future<void> sendOtp(BuildContext context, Map<String, dynamic> body) async {
    try {
      dynamic res = await authRepo.sendOtp(body);
      setIsLoading(false);

      Future.delayed(const Duration(microseconds: 500), () {
        print("navigation called");
        //change route to OTP screen
        Navigator.pushReplacementNamed(context, RouteName.otpScreen,
            arguments: res['data']);
        Utils.showSnackBar(context, res['message']);
      });
    } catch (error) {
      setIsLoading(false);
      if (error is AppException) {
        print("inside app exception: ${error.error}");
        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }

  //sends pswd reset OTP with phone num
  Future<void> verifyPwdResetOtp(
      BuildContext context, Map<String, dynamic> body) async {
    try {
      dynamic res = await authRepo.verifyOtp(body);
      setIsLoading(false);

      Future.delayed(const Duration(microseconds: 500), () {
        print("navigation called");
        //change route to Password Reset screen
        Navigator.pushReplacementNamed(context, RouteName.pswdResetScreen,
            arguments: res);
        Utils.showSnackBar(context, res['message']);
      });
    } catch (error) {
      setIsLoading(false);
      if (error is AppException) {
        print("inside app exception: ${error.error}");
        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }

  Future<void> verifyRegistrationtOtp(
      BuildContext context, Map<String, dynamic> body) async {
    try {
      dynamic res = await authRepo.verifyOtp(body);
      setIsLoading(false);

      Future.delayed(const Duration(microseconds: 500), () {
        print("navigation called");
        //change route to Login screen
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.loginScreen, (route) => false);
        Utils.showSnackBar(context, res['message']);
      });
    } catch (error) {
      setIsLoading(false);
      if (error is AppException) {
        print("inside app exception: ${error.error}");
        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }

  Future<void> passwordChange(
      BuildContext context, Map<String, dynamic> body) async {
    try {
      dynamic res = await authRepo.pswdChange(body);
      setIsLoading(false);

      Future.delayed(const Duration(microseconds: 500), () {
        print("navigation called");
        //change route to Login screen
        Navigator.pushReplacementNamed(context, RouteName.profileScreen);
        Utils.showSnackBar(context, res['message']);
      });
    } catch (error) {
      setIsLoading(false);
      if (error is AppException) {
        print("inside app exception: ${error.error}");
        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }

  Future<void> passwordReset(
      BuildContext context, Map<String, dynamic> body) async {
    try {
      dynamic res = await authRepo.pswdReset(body);
      setIsLoading(false);

      Future.delayed(const Duration(microseconds: 500), () {
        print("navigation called");
        //change route to Login screen
        Navigator.pushReplacementNamed(context, RouteName.loginScreen);
        Utils.showSnackBar(context, res['message']);
      });
    } catch (error) {
      setIsLoading(false);
      if (error is AppException) {
        print("inside app exception: ${error.error}");
        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }
}
