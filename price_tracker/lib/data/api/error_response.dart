///Generic error response class that is being used by all the API calls.
class PTErrorResponse {
  int? code;
  String message;

  PTErrorResponse({required this.code, required this.message});
}
