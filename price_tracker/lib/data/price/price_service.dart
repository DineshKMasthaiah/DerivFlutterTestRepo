import 'dart:convert';

import 'package:price_tracker/data/api/generic_response.dart';
import 'package:price_tracker/data/api/web_socket_client.dart';
import 'package:price_tracker/data/price/price_request.dart';
import 'package:price_tracker/data/price/price_response.dart';
import 'package:price_tracker/utils/logger.dart';

class PTPriceService {
  PTWebSocketClient webSocketClient;

  PTPriceService(this.webSocketClient);

  Future<bool> sendSymbol(String symbol) async {
    PriceRequest request = PriceRequest(ticks: symbol);
    webSocketClient.sendMessage(jsonEncode(request));
    return true;
  }

  void listenForBroadCast(Function(PTGenericResponse) onEvent) {
    webSocketClient.listenForBroadCast((genericResponse) {
      if (genericResponse.isSuccessful) {
        PriceDataModel priceDataModel =
            PriceDataModel.fromJson(jsonDecode((genericResponse).data));
        PTLogger.log(
            "Got price ${priceDataModel.tick?.quote} for ${priceDataModel.tick?.symbol}");
        genericResponse.data = priceDataModel;
      }
      onEvent(genericResponse);
    });
  }
}
