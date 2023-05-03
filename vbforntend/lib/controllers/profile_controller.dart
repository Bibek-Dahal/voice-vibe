import 'package:flutter/material.dart';
import 'package:vbforntend/data/app_exception.dart';
import 'package:vbforntend/data/response/api_response.dart';
import 'package:vbforntend/data/response/status.dart';
import 'package:vbforntend/models/profile.dart';
import 'package:vbforntend/repository/user_repository.dart';
import 'package:vbforntend/utils/lodable.dart';
import 'package:vbforntend/utils/utils.dart';

class ProfileController extends ChangeNotifier {
  UserRepository userRepository = UserRepository();
  ApiResponse<dynamic> apiResponse = ApiResponse.loading();
  bool isLoading = false;
  setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
    print("after notify listner");
  }

  setResponse(ApiResponse<dynamic> response) {
    print("set res called");
    print("res inside set: $response");
    apiResponse = response;
    notifyListeners();
  }

  // setResponse(Map<String, dynamic> response) {
  //   print("set res called");
  //   print("res inside set: $response");
  //   apiResponse.data = Profile.fromJson(response['data']);
  //   apiResponse.status = Status.COMPLETED;
  //   notifyListeners();
  // }

  Future<void> fetchProfile(BuildContext context) async {
    try {
      // setLoading(Status.LOADING);
      Map<String, dynamic> res = await userRepository.fetchProfile(context);
      Profile profile = Profile.fromJson(res['data']);
      setResponse(ApiResponse<Profile>.completed(
          data: profile, message: res['message']));
    } catch (error) {
      setIsLoading(false);
      // print("register error: $error");
      // print(error);
      if (error is AppException) {
        print("inside app exception: ${error.error}");
        setResponse(ApiResponse<Profile>.error(error.error));
        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }
}
