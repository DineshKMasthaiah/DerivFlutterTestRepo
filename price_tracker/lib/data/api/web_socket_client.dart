import 'package:price_tracker/data/api/error_response.dart';
import 'package:price_tracker/data/api/generic_response.dart';
import 'package:price_tracker/data/price/price_response.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PTWebSocketClient  {
  static const String _baseURL =
      'wss://ws.binaryws.com/websockets/v3?app_id=1089';
  WebSocketChannel? _channel;
  WebSocketChannel? get channel =>_channel;
  bool isListening = false;
  PTWebSocketClient();


  void sendMessage(String message) {
    if (_channel == null) {
      _connect();
    }
    _channel?.sink.add(message);
  }

  void _connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse(_baseURL),
    );
  }

  void listenForBroadCast(Function(PTGenericResponse) onEvent) async {
    if(isListening){
      return;
    }
    isListening = true;
    PTGenericResponse eventResponse;
    _channel?.stream.listen((eventJson) {
      eventResponse = PTGenericResponse(isSuccessful: true, data: eventJson);
      onEvent(eventResponse);
    }).onError((error) {
      eventResponse = PTGenericResponse(
          isSuccessful: false,
          errorResponse: PTErrorResponse(code: -1, message: error));
      onEvent(eventResponse);
    });
  }

  /// Fetch symbols and markets. one time call. stream closes itself after receiving first event
  Future oneTimeFetch(String message) {
    WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse(_baseURL),
    );
    channel.sink.add(message);
    return channel.stream.first;
  }

  Future<void> unsubscribe() async {
   _channel?.sink.close();
  }
}
