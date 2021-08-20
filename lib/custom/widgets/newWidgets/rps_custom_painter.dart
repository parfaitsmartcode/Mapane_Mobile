import 'dart:ui' as ui;

import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
//     size: Size(50, (50*1).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//     painter: RPSCustomPainter(),
// )

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.3676471, 0);
    path_0.lineTo(size.width * 0.3676471, 0);
    path_0.arcToPoint(Offset(size.width * 0.7352941, size.height * 0.3676471),
        radius:
            Radius.elliptical(size.width * 0.3676471, size.height * 0.3676471),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.7352941, size.height * 0.7352941);
    path_0.arcToPoint(Offset(size.width * 0.7352941, size.height * 0.7352941),
        radius: Radius.elliptical(0, 0),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.3676471, size.height * 0.7352941);
    path_0.arcToPoint(Offset(0, size.height * 0.3676471),
        radius:
            Radius.elliptical(size.width * 0.3676471, size.height * 0.3676471),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(0, size.height * 0.3676471);
    path_0.arcToPoint(Offset(size.width * 0.3676471, 0),
        radius:
            Radius.elliptical(size.width * 0.3676471, size.height * 0.3676471),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawShadow(path_0, Colors.black, 3, false);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

