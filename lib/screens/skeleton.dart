import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapane/routes.dart';
import '../utils/theme_mapane.dart';
import 'package:mapane/utils/size_config.dart';

class Skeleton extends StatefulWidget {
  final double height;
  final double width;

  Skeleton({Key key, this.height = 21, this.width = 215 }) : super(key: key);

  createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear
      ),
    )..addListener(() {
      setState(() {});
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width:  215,
        height: 1, 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment(gradientPosition.value, 0),
            end: Alignment(-1, 0),
            colors: [Colors.black12, Colors.black26, Colors.black12]
          )
        ),
    );
  }
}