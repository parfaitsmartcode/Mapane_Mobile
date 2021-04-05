import 'package:flutter/material.dart';
import 'package:near_me/utils/hexcolor.dart';

class CurvePainter extends CustomPainter {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double x3;
  final double y3;
  final Color color;
  CurvePainter(this.x1,this.y1,this.x2,this.y2,this.x3,this.y3,this.color);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.stroke;

    var path = Path();
    print("size " + size.width.toString());
    paint.strokeWidth = 5;
    path.moveTo(x1, y1);
    path.cubicTo(x1, y1, x2, y2, x3, y3);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}