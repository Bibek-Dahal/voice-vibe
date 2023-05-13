import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vbforntend/data/app_exception.dart';
import 'package:vbforntend/data/response/api_response.dart';
import 'package:vbforntend/models/notification.dart';
import 'package:vbforntend/repository/notification_repository.dart';
import 'package:vbforntend/utils/utils.dart';

class NotificationController extends ChangeNotifier {
  NotificationRepository notificationRepository = NotificationRepository();
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

  Future<void> listNotifications(BuildContext context) async {
    try {
      // setLoading(Status.LOADING);
      Map<String, dynamic> res =
          await notificationRepository.listNotifications(context);
      print(res);
      var data = res['data'];
      List<NotificationModel> notifications = List<NotificationModel>.generate(
          data.length, (i) => NotificationModel.fromJson(data[i]));

      setResponse(ApiResponse<List<NotificationModel>>.completed(
          data: notifications, message: res['message']));
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

  Future<void> retriveNotification(BuildContext context, String id) async {
    try {
      // setLoading(Status.LOADING);
      Map<String, dynamic> res =
          await notificationRepository.retriveNotifications(context, id);
      NotificationModel notification = NotificationModel.fromJson(res['data']);
      setResponse(ApiResponse<NotificationModel>.completed(
          data: notification, message: res['message']));
    } catch (error) {
      setIsLoading(false);
      // print("register error: $error");
      // print(error);
      if (error is AppException) {
        print("inside app exception: ${error.error}");
        setResponse(ApiResponse<NotificationModel>.error(error.error));
        Utils.showAlertBox(context, error.error);
      } else {
        //  Utils.showAlertBox(context, error.message);
        print(error);
      }
    }
  }
}
