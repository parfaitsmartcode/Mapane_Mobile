import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Di{

  final String apiUrl = "http://mapane.smartcodegroup.com";

  Dio dio = new Dio();

  IO.Socket socket = IO.io("http://mapane.smartcodegroup.com");

}