import 'package:flutter/material.dart';

class CustomTextForm extends StatefulWidget {
  final placeholder;
  const CustomTextForm({Key key, this.placeholder}) : super(key: key);

  @override
  _CustomTextFormState createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Enter your username',
      ),
    );
  }
}
