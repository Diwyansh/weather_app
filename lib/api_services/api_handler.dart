class APIHandler {
  Status? status;
  String? message;
  bool? isSuccess;
  dynamic data;

  APIHandler({this.status, this.message, this.isSuccess, this.data});
}

enum Status {
  loading,
  completed,
}