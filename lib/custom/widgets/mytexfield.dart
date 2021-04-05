import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Widget prefixIcon;
  final String hintText;
  final EdgeInsets contentPadding;

  MyTextField({this.prefixIcon,this.hintText,this.contentPadding = const EdgeInsets.symmetric(horizontal: 30, vertical: 16)});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
          color: Colors.white
      ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 20.0,
          ),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3),width: 2),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3),width: 2),
              borderRadius: BorderRadius.circular(20)),
        )
    );
  }
}
