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
  ApiResponse<User> apiResponse = ApiResponse.loading();
  bool isLoading = false;
  setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setResponse(Map<String, dynamic> response) {
    apiResponse.data = User.formJson(response);
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
      setResponse(res);
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
}
