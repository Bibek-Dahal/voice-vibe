import 'dart:io';

abstract class BaseApiServices {
  Future<dynamic> getApiResponse(String url, {Map<String, String>? headers});

  Future<dynamic> postApiResponse(String url,
      {required dynamic body, Map<String, String>? headers});
  Future<dynamic> putApiResponse(String url,
      {required dynamic body, Map<String, String>? headers});
  Future<dynamic> deleteApiResponse(String url, {Map<String, String>? headers});
  Future<dynamic> patchApiResponse(String url,
      {required dynamic body, Map<String, String>? headers});

  Future<dynamic> postMultipartApiResponse(String url,
      {required dynamic body,
      required Map<String, dynamic> files,
      Map<String, String>? headers});
}
