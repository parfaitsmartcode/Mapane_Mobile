import 'package:flutter/material.dart';
import 'package:mapane/constants/socket.dart';
import 'package:provider/provider.dart';
import '../state/user_provider.dart';

class MyAppSocket extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyAppSocket> {
  // void test() => Sockete.emit('test_connection');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(child: Center(child: RaisedButton(
      onPressed: (){
        context.read<UserProvider>().testSocket();
      },
      child: Text('Tester'),
    ))));
  }
}
