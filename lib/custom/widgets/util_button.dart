import 'package:flutter/material.dart';

class UtilButton extends StatelessWidget {
  final Widget icon;
  final double height;
  final double width;
  final Function onTap;

  UtilButton({this.icon, this.width, this.height, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 7,
            blurRadius: 30,
            offset: Offset(0, 3), // changes position of shadow
          )
        ]),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }
}
