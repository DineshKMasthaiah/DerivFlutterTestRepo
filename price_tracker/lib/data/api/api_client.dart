import 'package:web_socket_channel/web_socket_channel.dart';

class PTApiClient  {
  static const String _baseURL =
      'wss://ws.binaryws.com/websockets/v3?app_id=1089';
  WebSocketChannel? _channel;
  WebSocketChannel? get channel =>_channel;

  PTApiClient();


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
