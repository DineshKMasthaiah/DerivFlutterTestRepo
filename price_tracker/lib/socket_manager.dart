import 'package:web_socket_channel/web_socket_channel.dart';

class SocketManager {
  /// connects to internet
  /// gets responses
  /// parses response
  WebSocketChannel channel;
  SocketManager({required this.channel});

  sendMessage(String message){
    channel.sink.add(message);
  }
 listen(){

 }

}
