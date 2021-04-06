import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyTextField extends StatelessWidget {
  final Widget prefixIcon;
  final Widget suffixIcon;
  final String hintText;
  final EdgeInsets contentPadding;
  final Function onTap;

  MyTextField({this.prefixIcon,this.hintText,this.suffixIcon,this.onTap,this.contentPadding = const EdgeInsets.symmetric(horizontal: 30, vertical: 16)});
  @override
  Widget build(BuildContext context) {
    return TextFormField(

      onTap: onTap,
      style: TextStyle(
          color: Colors.white
      ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          suffix: suffixIcon,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 15.0.sp,
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
