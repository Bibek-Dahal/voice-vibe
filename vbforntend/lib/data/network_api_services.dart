import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vbforntend/data/app_exception.dart';
import 'package:vbforntend/data/base_api_services.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApiResponse(String url,
      {Map<String, String>? headers}) async {
    dynamic responseJson;
    try {
      print(url);
      final response = await http.get(Uri.parse(url), headers: headers).timeout(
            const Duration(seconds: 10),
          );
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(['Cannot connect to server']);
    } on TimeoutException {
      throw RequestTimeOutException(['Request Timeout']);
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApiResponse(String url,
      {required dynamic body, Map<String, String>? headers}) async {
    print(url);
    dynamic responseJson;
    try {
      print("post api called");
      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));
      // print(body);
      var data = jsonDecode(response.body);
      // print(data);
      responseJson = returnResponse(response);
      print("after resJson called");
    } on SocketException {
      throw InternetException(['Cannot connect to server']);
    } on TimeoutException {
      throw TimeoutException('Request Timeout');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future<dynamic> patchApiResponse(String url,
      {required body, Map<String, String>? headers}) async {
    print(url);
    dynamic responseJson;
    try {
      print("post api called");
      final response = await http
          .patch(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));
      // print(body);
      var data = jsonDecode(response.body);
      // print(data);
      responseJson = returnResponse(response);
      print("after resJson called");
    } on SocketException {
      throw InternetException(['Cannot connect to server']);
    } on TimeoutException {
      throw TimeoutException('Request Timeout');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future postMultipartApiResponse(String url,
      {required dynamic body,
      required Map<String, dynamic> files,
      Map<String, String>? headers}) async {
    print("multipart called");
    // TODO: implement postMultipartApiResponse
    String img_path = files['profile_pic'] as String;
    print(img_path.runtimeType);
    print(body);

    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    // ..fields['favourite_topic'] = body['favourite_topics'];

    // Encode each key-value pair in the map as a separate part in the multipart request
    body.forEach((key, values) {
      for (var value in values) {
        request.fields[key] = value;
      }
    });
    request.files
        .add(await http.MultipartFile.fromPath('profile_pic', img_path));

    request.headers.addAll(headers!);
    print(request.headers);

    //decides whether to upload single fle for one field or List of file for one lield
    // List keys = files.keys.toList();
    // for (var field in keys) {
    //   if (files[field] is List) {
    //     request.files.add(field.map((filepath) async =>
    //         await http.MultipartFile.fromPath(field, filepath)));
    //   } else {
    //     request.files
    //         .add(await http.MultipartFile.fromPath(field, files[field]));
    //   }
    // }
    // request.send();

    dynamic responseJson;
    try {
      print(("inside try"));
      final response = await request.send();
      // http.StreamedResponse
      print("request sent");
      print(response.reasonPhrase);
      var streamedResponse = await http.Response.fromStream(response);
      responseJson = returnResponse(streamedResponse);
    } on SocketException {
      throw InternetException(['Cannot connect to server']);
    } on TimeoutException {
      throw TimeoutException('Request Timeout');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future<dynamic> putApiResponse(String url,
      {required dynamic body, Map<String, String>? headers}) async {
    dynamic responseJson;
    try {
      final response = await http
          .put(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(['Cannot connect to server']);
    } on TimeoutException {
      throw TimeoutException('Request Timeout');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future<dynamic> deleteApiResponse(String url,
      {Map<String, String>? headers}) async {
    dynamic responseJson;
    try {
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException(['Cannot connect to server']);
    } on TimeoutException {
      throw TimeoutException('Request Timeout');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    Map<String, dynamic> responseJson;
    print("return response caled");

    responseJson = jsonDecode(response.body) as Map<String, dynamic>;

    dynamic error;
    final int statusCode = response.statusCode;
    print("status code: $statusCode");
    print(responseJson);

    if (responseJson.containsKey('errors')) {
      var a = responseJson['errors'] as Map<String, dynamic>;
      if (a.containsKey('non_field_errors')) {
        print("error contains non_field_error");
        print(responseJson['errors']['non_field_errors']);
        error = responseJson['errors']['non_field_errors'];
        print(error);
      } else if (a.containsKey('details')) {
        print("error contains error details");
        error = responseJson['errors']['details'];
        print(error);
      } else {
        error = a;
      }
    }

    // if (responseJson['errors']['non_fields_errors'] != null) {
    //   print("first if");
    //   print(responseJson['errors']['non_fields_errors']);
    // }

    // if (responseJson['errors']['details'] != null) {
    //   print("second if");
    //   error = responseJson['errors']['details'];
    // }
    // print("after null");

    // print(responseJson.runtimeType);

    switch (statusCode) {
      case 200:
        return responseJson;
      case 201:
        print("created called");
        return responseJson;
      case 400:
        throw BadRequestException(error, statusCode);
      case 404:
        throw UrlNotFoundException(error, statusCode);
      case 401:
        throw UnauthorisedException(['user is not authorized'], statusCode);

      case 403:
        throw ForbiddenException(error, statusCode);
      case 500:
        throw InternalServerErrorException(error, statusCode);
      case 452:
        throw UserNotVerifiedException(error, statusCode);
      default:
        throw FetchDataException(
            ['Error Occoured While Communicating With Server'], statusCode);
    }
  }
}
