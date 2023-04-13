import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vbforntend/data/app_exception.dart';
import 'package:vbforntend/data/response/api_response.dart';
import 'package:vbforntend/repository/user_repository.dart';
import 'package:vbforntend/utils/lodable.dart';
import 'package:vbforntend/utils/utils.dart';

class UserController extends Lodable with ChangeNotifier {
  UserController() : super(false);

  UserRepository userRepository = UserRepository();
  late ApiResponse apiResponse;

  setIsLoading(bool value) {
    super.isLoading = value;
    notifyListeners();
  }

  Future<dynamic> upload(BuildContext context, file, body) async {
    setIsLoading(true);
    print("file path: $file");
    try {
      var res = await userRepository.updatePfofile(context, file, body);
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
}
