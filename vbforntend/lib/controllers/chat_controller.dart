import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vbforntend/data/app_exception.dart';
import 'package:vbforntend/data/response/api_response.dart';
import 'package:vbforntend/models/chat.dart';
import 'package:vbforntend/repository/chat_repository.dart';
import 'package:vbforntend/utils/utils.dart';

class ChatController extends ChangeNotifier {
  ChatRepository chatRepository = ChatRepository();

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

  Future<void> listChats(BuildContext context, String id) async {
    try {
      // setLoading(Status.LOADING);
      Map<String, dynamic> res = await chatRepository.listChats(context, id);
      print(res);
      var space = res['data'];
      List<Chat> spaces =
          List<Chat>.generate(space.length, (i) => Chat.fromJson(space[i]));

      apiResponse = ApiResponse<List<Chat>>.completed(spaces);
      setResponse(ApiResponse<List<Chat>>.completed(spaces));
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
