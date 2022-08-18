
import 'package:price_tracker/data/api/error_response.dart';

///Generic response class that is being used by all the API calls.
class PTGenericResponse<T> {
  bool isSuccessful;
  String? jsonBody;
  T? data;
  PTErrorResponse? errorResponse;
  Map<String, dynamic>? mappedData;

  PTGenericResponse(
      {required this.isSuccessful,
        this.jsonBody,
        this.data,
        this.errorResponse,
        this.mappedData});
}
