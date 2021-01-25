import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapane/constants/assets.dart';
import 'package:mapane/utils/size_config.dart';

class Alert extends StatelessWidget {
  final String title;
  final Color color;
  final radius;
  final SvgPicture picture;
  Alert({@required this.title, this.color, this.picture, this.radius});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      /*width: SizeConfig.blockSizeHorizontal * 4,
      height: SizeConfig.blockSizeVertical * 10,*/
      height: SizeConfig.blockSizeVertical * 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: radius,
            child: picture,
          ),
          Expanded(
            child: Text(
              title,
              //overflow: TextOverflow.clip,
            ),
          )
        ],
      ),
    );
  }
}
