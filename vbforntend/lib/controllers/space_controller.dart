import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vbforntend/data/app_exception.dart';
import 'package:vbforntend/data/response/api_response.dart';
import 'package:vbforntend/data/response/status.dart';
import 'package:vbforntend/models/space.dart';
import 'package:vbforntend/repository/space_repository.dart';
import 'package:vbforntend/utils/utils.dart';

class SpaceController extends ChangeNotifier {
  SpaceRepository spaceRepository = SpaceRepository();

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

  Future<void> fetchProfile(BuildContext context) async {
    try {
      // setLoading(Status.LOADING);
      Map<String, dynamic> res = await spaceRepository.listSpace(context);
      print(res);
      var space = res['data'];
      List<Space> spaces =
          List<Space>.generate(space.length, (i) => Space.fromJson(space[i]));

      // apiResponse = ApiResponse<List<Space>>.completed(spaces);
      setResponse(ApiResponse<List<Space>>.completed(spaces, res['message']));
    } catch (error) {
      setIsLoading(false);

      if (error is AppException) {
        print("inside app exception: ${error.error}");
        Utils.showAlertBox(context, error.error);
        setResponse(ApiResponse.error(error.error));
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }
}
