import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/data/api/requests/active_symbol_request.dart';
import 'package:price_tracker/data/api/requests/price_request.dart';
import 'package:price_tracker/utils/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'api/responses/price_response.dart';

class PTPriceCubit extends Cubit<String> {
  static const String baseURL = 'wss://ws.binaryws.com/websockets/v3?app_id=1089';
  WebSocketChannel? _channel;
  PTPriceCubit() : super("");

  Future<void> unsubscribe() async {
    return await close();
  }

  void onSymbolChange(String symbol) {
    PriceRequest request = PriceRequest(ticks: symbol);
    if (_channel != null) {
      _channel?.sink.add(jsonEncode(request));
      return;
    }
    _channel = WebSocketChannel.connect(
      Uri.parse(baseURL),
    );
    _channel?.sink.add(jsonEncode(request));
    _channel?.stream.listen((event) {
      PriceResponse model = PriceResponse.fromJson(jsonDecode(event));
      PTLogger.log("Got price ${model.tick?.quote} for ${model.tick?.symbol}");
      emit(model.tick?.quote.toString() ?? "none");
    }).onError((error) {
      //TODO: handle error here
    });
  }

  /// Fetch symbols and markets. one time call. stream closes itself after receiving first event
  Future getSymbols() {
    WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse(baseURL),
    );
    ActiveSymbolRequest symbolRequest =
        ActiveSymbolRequest(activeSymbols: 'brief', productType: 'basic');
    channel.sink.add(jsonEncode(symbolRequest));
    return channel.stream.first;
  }
}
