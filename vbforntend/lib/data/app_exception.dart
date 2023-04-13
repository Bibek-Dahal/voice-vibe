class AppException implements Exception {
  // final String message;
  dynamic error;
  int? statusCode;
  AppException(this.error, this.statusCode);

  // String get getMessage => message;
  // String get getCode => message;

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   // return errors;
  //   return "sorry";
  // }
}

class BadRequestException extends AppException {
  BadRequestException(dynamic error, int statusCode) : super(error, statusCode);
}

class UnauthorisedException extends AppException {
  UnauthorisedException(dynamic error, int statusCode)
      : super(error, statusCode);
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException(dynamic error, int statusCode)
      : super(error, statusCode);
}

class UrlNotFoundException extends AppException {
  UrlNotFoundException(dynamic error, int statusCode)
      : super(error, statusCode);
}

class InternetException extends AppException {
  InternetException(dynamic error, [int? statusCode])
      : super(error, statusCode);
}

class RequestTimeOutException extends AppException {
  RequestTimeOutException(dynamic error, [int? statusCode])
      : super(error, statusCode);
}

class FetchDataException extends AppException {
  FetchDataException(dynamic error, [int? statusCode])
      : super(error, statusCode);
}

class UserNotVerifiedException extends AppException {
  UserNotVerifiedException(dynamic error, [int? statusCode])
      : super(error, statusCode);
}
