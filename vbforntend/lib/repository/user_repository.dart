import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/data/base_api_services.dart';
import 'package:vbforntend/data/network_api_services.dart';
import 'package:vbforntend/models/user.dart';
import 'package:vbforntend/providers/user_provider.dart';
import 'package:vbforntend/utils/app_url.dart';

class UserRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> updatePfofile(
      BuildContext context, Map<String, dynamic> file, String id) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.getToken;
    // token = "Bearer $token";
    // print("token $token");
    // "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MzU2OGU4ZDBhZWQwMGJiNDFhNDA3MyIsImlhdCI6MTY4MTIyNzE5OCwiZXhwIjoxNjgyNTIzMTk4fQ.3-zhE8ZaOBIGUgrrbzW6pOosFQtwCns472Rn3pFzeHk";
    Map<String, String> header = {
      'Authorization': "Bearer $token",
      'Content-Type': 'application/json'
    };
    // try {
    var response = await _apiServices.postMultipartApiResponse(
        "${AppUrl.update_profile}/${id}",
        files: file,
        headers: header);
    print(response);
    return response;
    // } catch (error) {
    //   print(error);
    // }
  }

  Future<dynamic> fetchLoggedUser(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.getToken;
    Map<String, String> header = {
      'Authorization': "Bearer $token",
      'Content-Type': 'application/json'
    };
    var response = await _apiServices.getApiResponse(AppUrl.get_logged_user,
        headers: header);
    return response;
  }

  Future<dynamic> fetchProfile(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.getToken;
    Map<String, String> header = {
      'Authorization': "Bearer $token",
      'Content-Type': 'application/json'
    };
    var response =
        await _apiServices.getApiResponse(AppUrl.get_profile, headers: header);
    return response;
  }

  Future<dynamic> updateUser(BuildContext context, dynamic body) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    User user = userProvider.user!;
    String? token = userProvider.getToken;
    Map<String, String> header = {
      'Authorization': "Bearer $token",
      'Content-Type': 'application/json'
    };

    print("body: $body");
    var response = await _apiServices.patchApiResponse(
        "${AppUrl.update_user}/${user.id}",
        headers: header,
        body: body);
    return response;
  }
}
