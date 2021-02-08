import 'package:flutter/material.dart';
import 'package:mapane/custom/widgets/notification_widget.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: NotificationMapane(),
    );
  }
}
