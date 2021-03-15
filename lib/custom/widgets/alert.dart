import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapane/utils/size_config.dart';

class Alert extends StatelessWidget {
  final String title;
  final Color color;
  final radius;
  final SvgPicture picture;
  final Function onTap;
  Alert({@required this.title, this.color, this.picture, this.radius,this.onTap});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap ,
          child: CircleAvatar(
            backgroundColor: color,
            radius: radius,
            child: Center(
              child: picture
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize : 12.0,
                  color: Colors.grey
                )
                //overflow: TextOverflow.clip,
              ),
            ),
          ],
        )
      ],
    );
  }
}
