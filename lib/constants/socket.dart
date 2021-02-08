// import 'package:Mapane/di.dart';
// import 'package:Mapane/service_locator.dart';
// import 'package:socket_io_client/socket_io_client.dart' as client;


// class SocketHelper{
//   static const _url = 'https://together.smartcodegroup.com';

//   static client.Socket _socket = locator<Di>().socket;

//   static _initialize() {
//     /*if (_socket != null) return;

//     _socket = client.io(
//       _url
//     );*/
//     _socket.on('connect', (_) => print('Connected'));
//     _socket.connect();
//   }

//   static emit(String event, {dynamic arguments}) {
//     _initialize(); // Ensure it's initialized
//     _socket.emit(event, arguments ?? {});
//     print(event);
//   }

//   static subscribe(String event, Function function) {
//     _initialize(); // Ensure it's initialized
//     _socket.on(event, function);
//   }

//   static unsubscribe(String event, Function function) {
//     _initialize(); // Ensure it's initialized
//     _socket.off(event, function);
//   }
// }