import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vbforntend/data/app_exception.dart';
import 'package:vbforntend/data/response/api_response.dart';
import 'package:vbforntend/models/user.dart';
import 'package:vbforntend/repository/user_repository.dart';
import 'package:vbforntend/utils/lodable.dart';
import 'package:vbforntend/utils/utils.dart';

class UserController extends ChangeNotifier {
  UserRepository userRepository = UserRepository();
  ApiResponse<dynamic> apiResponse = ApiResponse.loading();
  bool isLoading = false;
  setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // setResponse(Map<String, dynamic> response) {
  //   apiResponse.data = User.formJson(response);
  //   notifyListeners();
  // }

  setResponse(ApiResponse<dynamic> response) {
    print("set res called");
    print("res inside set: $response");
    apiResponse = response;
    notifyListeners();
  }

  Future<dynamic> upload(BuildContext context, file, [body]) async {
    setIsLoading(true);
    apiResponse = ApiResponse.loading();
    print("file path: $file");
    try {
      var res = await userRepository.updatePfofile(context, file);
      Future.delayed(const Duration(seconds: 0), () {
        Utils.showSnackBar(context, res['message']);
      });
      setIsLoading(false);
    } catch (error) {
      setIsLoading(false);
      // print("register error: $error");
      // print(error);
      if (error is AppException) {
        print("inside app exception: ${error.error}");
        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }

  Future<void> fetchLoggedUser(BuildContext context) async {
    try {
      Map<String, dynamic> res = await userRepository.fetchLoggedUser(context);
      User user = User.formJson(res['data']);
      setResponse(
          ApiResponse<User>.completed(data: user, message: res['message']));

      // setResponse(res);
    } catch (error) {
      setIsLoading(false);
      // print("register error: $error");
      // print(error);
      if (error is AppException) {
        print("inside app exception: ${error.error}");
        setResponse(ApiResponse<User>.error(error.error));
        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }

  Future<void> updateUser(BuildContext context, dynamic body) async {
    try {
      Map<String, dynamic> res = await userRepository.updateUser(context, body);
      User user = User.formJson(res['data']);
      print(res);
      setResponse(ApiResponse<User>.completed(message: res['message']));

      // setResponse(res);
    } catch (error) {
      setIsLoading(false);
      // print("register error: $error");
      // print(error);
      if (error is AppException) {
        print("inside app exception: ${error.error}");
        setResponse(ApiResponse<User>.error(error.error));
        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }
}
