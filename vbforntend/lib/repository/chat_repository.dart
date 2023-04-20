import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/data/base_api_services.dart';
import 'package:vbforntend/data/network_api_services.dart';
import 'package:vbforntend/providers/user_provider.dart';
import 'package:vbforntend/utils/app_url.dart';

class ChatRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> listChats(BuildContext context, String id) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.getToken;

    Map<String, String> header = {'Authorization': "Bearer $token"};

    var response = await _apiServices.getApiResponse("${AppUrl.chat}/$id",
        headers: header);
    print(response);
    return response;
  }
}
