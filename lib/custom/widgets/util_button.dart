import 'package:flutter/material.dart';

class UtilButton extends StatelessWidget {
  final Icon icon;
  final double height;
  final double width;
  final Function onTap;

  UtilButton({
    this.icon,
    this.width,
    this.height,
    this.onTap
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0)
          ),
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }
}
