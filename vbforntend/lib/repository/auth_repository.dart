import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vbforntend/data/base_api_services.dart';
import 'package:vbforntend/data/network_api_services.dart';

import 'package:vbforntend/utils/app_url.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiServices();
  Future<dynamic> signup(dynamic body) async {
    dynamic res =
        await _apiServices.postApiResponse(AppUrl.register, body: body);
    // return Future.delayed(const Duration(seconds: 3), () {
    // return {'name': 'bibek'};
    // });
    return res;
  }

  Future<dynamic> login(dynamic body) async {
    dynamic res = await _apiServices.postApiResponse(AppUrl.login, body: body);
    return res;
  }

  Future<dynamic> sendOtp(dynamic body) async {
    dynamic res =
        await _apiServices.postApiResponse(AppUrl.send_otp, body: body);
    return res;
  }

  Future<dynamic> verifyOtp(dynamic body) async {
    dynamic res =
        await _apiServices.postApiResponse(AppUrl.verify_otp, body: body);
    return res;
  }

  Future<dynamic> pswdChange(dynamic body) async {
    dynamic res =
        await _apiServices.postApiResponse(AppUrl.pswd_change, body: body);
    return res;
  }

  Future<dynamic> pswdReset(dynamic body) async {
    dynamic res =
        await _apiServices.postApiResponse(AppUrl.pswd_reset, body: body);
    return res;
  }

  //other functions to be added
}
