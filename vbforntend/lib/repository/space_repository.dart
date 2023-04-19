import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/data/base_api_services.dart';
import 'package:vbforntend/data/network_api_services.dart';
import 'package:vbforntend/providers/user_provider.dart';
import 'package:vbforntend/utils/app_url.dart';

class SpaceRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> createSpace(
      BuildContext context, Map<String, dynamic> body) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.getToken;

    Map<String, String> header = {'Authorization': "Bearer $token"};
    // try {
    var response = await _apiServices.postApiResponse(AppUrl.space,
        body: body, headers: header);
    print(response);
    return response;
  }

  Future<dynamic> updateSpace(
      BuildContext context, Map<String, dynamic> body, String id) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.getToken;

    Map<String, String> header = {'Authorization': "Bearer $token"};

    var response = await _apiServices.patchApiResponse("${AppUrl.space}/$id",
        body: body, headers: header);
    print(response);
    return response;
  }

  Future<dynamic> retriveSpace(BuildContext context, String id) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.getToken;

    Map<String, String> header = {'Authorization': "Bearer $token"};

    var response = await _apiServices.getApiResponse("${AppUrl.space}/$id",
        headers: header);
    print(response);
    return response;
  }

  Future<dynamic> listSpace(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.getToken;

    Map<String, String> header = {'Authorization': "Bearer $token"};

    var response = await _apiServices.getApiResponse(AppUrl.get_all_space,
        headers: header);
    print(response);
    return response;
  }

  Future<dynamic> deleteSpace(BuildContext context, String id) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.getToken;

    Map<String, String> header = {'Authorization': "Bearer $token"};

    var response = await _apiServices.deleteApiResponse("${AppUrl.space}/$id",
        headers: header);
    print(response);
    return response;
  }
}
