import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:provider/provider.dart';

class topBar extends StatelessWidget {
  const topBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: getSize(17, "height", context)),
          child: Image.asset(
            'assets/images/Logo-long-blanc.png',
            height: getSize(39, "height", context),
          ),
        ),
        Container(
          // height: getSize(0, "height", context),
          width: getSize(103, "width", context),
          padding: EdgeInsets.symmetric(
              vertical: getSize(9, "height", context),
              horizontal: getSize(30, "width", context)),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.16),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(getSize(10, "width", context)),
                  bottomLeft: Radius.circular(getSize(10, "width", context)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Text(
                  "Fr",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getSize(16, "height", context),
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6386B8)),
                ),
              ),
              InkWell(
                child: Text(
                  "|",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getSize(16, "height", context),
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF6386B8)),
                ),
              ),
              InkWell(
                child: Text(
                  "En",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: getSize(16, "height", context),
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF6386B8)),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
