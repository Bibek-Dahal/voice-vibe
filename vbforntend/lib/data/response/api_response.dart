import 'package:vbforntend/data/response/status.dart';

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;
  dynamic error;

  ApiResponse({this.status, this.data, this.message});

  ApiResponse.loading() : status = Status.LOADING;

  ApiResponse.completed({this.data, this.message}) : status = Status.COMPLETED;

  ApiResponse.error(this.error) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data: $data";
  }
}
