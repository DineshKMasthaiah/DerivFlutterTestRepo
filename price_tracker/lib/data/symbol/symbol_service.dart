import 'dart:convert';

import 'package:price_tracker/data/api/error_response.dart';
import 'package:price_tracker/data/api/generic_response.dart';
import 'package:price_tracker/data/api/web_socket_client.dart';
import 'package:price_tracker/data/symbol/active_symbol_request.dart';
import 'package:price_tracker/data/symbol/active_symbol_response.dart';

class PTSymbolService {
  PTWebSocketClient webSocketClient;

  PTSymbolService(this.webSocketClient);

  void sendMessage(String activeSymbols, String productType,
      Function(PTGenericResponse) callback) async {

    ActiveSymbolRequest symbolRequest = ActiveSymbolRequest(
        activeSymbols: activeSymbols, productType: productType);
    PTGenericResponse genericResponse;
    webSocketClient.oneTimeFetch(jsonEncode(symbolRequest)).then((json) {
      ActiveSymbolResponse model =
          ActiveSymbolResponse.fromJson(jsonDecode(json));
      genericResponse = PTGenericResponse(isSuccessful: true);
      genericResponse.data = model;
      callback(genericResponse);
    }).onError((error, stackTrace) {
      genericResponse = PTGenericResponse(isSuccessful: false);
      genericResponse.errorResponse =
          PTErrorResponse(code: -1, message: error.toString());
    });
  }
}
